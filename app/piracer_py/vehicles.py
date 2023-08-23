# Copyright (C) 2022 twyleg
import math
import time
import busio

from abc import abstractmethod
from board import SCL, SDA
from adafruit_pca9685 import PCA9685
from adafruit_ina219 import INA219
from adafruit_ssd1306 import SSD1306_I2C


class PiRacerBase:
    """
    Base class that contains everything common from PiRacer Standard and PiRacer Pro
    """
    PWM_RESOLUTION = 16
    PWM_MAX_RAW_VALUE = math.pow(2, PWM_RESOLUTION) - 1

    PWM_FREQ_50HZ = 50.0
    PWM_WAVELENGTH_50HZ = 1.0 / PWM_FREQ_50HZ
    PWM_FREQ_500HZ = 500.0
    PWM_WAVELENGTH_500HZ = 1.0 / PWM_FREQ_500HZ

    @classmethod
    def _set_channel_active_time(cls, time: float, pwm_controller: PCA9685, channel: int) -> None:
        raw_value = int(cls.PWM_MAX_RAW_VALUE * (time / cls.PWM_WAVELENGTH_50HZ))
        pwm_controller.channels[channel].duty_cycle = raw_value

    @classmethod
    def _get_50hz_duty_cycle_from_percent(cls, value: float) -> float:
        return 0.0015 + (value * 0.0005)

    def __init__(self) -> None:
        self.i2c_bus = busio.I2C(SCL, SDA)
        self.display = SSD1306_I2C(128, 32, self.i2c_bus, addr=0x3c)

    def _warmup(self) -> None:
        self.set_steering_percent(0.0)
        self.set_throttle_percent(0.0)
        time.sleep(2.0)

    def get_battery_voltage(self) -> float:
        """Returns the current battery voltage in V."""
        return self.battery_monitor.bus_voltage + self.battery_monitor.shunt_voltage

    def get_battery_current(self) -> float:
        """Returns the current battery current in mA."""
        return self.battery_monitor.current

    def get_power_consumption(self) -> float:
        """Returns the current power consumption of the system in W."""
        return self.battery_monitor.power

    def get_display(self) -> SSD1306_I2C:
        """Returns a display object to draw on the display."""
        return self.display

    @abstractmethod
    def set_steering_percent(self, value: float) -> None:
        pass

    @abstractmethod
    def set_throttle_percent(self, value: float) -> None:
        pass


class PiRacerPro(PiRacerBase):
    """
    Provides access to the periphery of the PiRacer Pro model.
    """

    PWM_STEERING_CHANNEL = 0
    PWM_THROTTLE_CHANNEL = 1

    def __init__(self) -> None:
        super().__init__()
        self.pwm_controller = PCA9685(self.i2c_bus, address=0x40)
        self.pwm_controller.frequency = self.PWM_FREQ_50HZ
        self.battery_monitor = INA219(self.i2c_bus, addr=0x42)

        self._warmup()

    def set_steering_percent(self, value: float) -> None:
        """Set the desired steering value in percent.

        :param float value: Steering angle in percent (left: 0.0 to -1.0, right: 0.0 to +1.0, neutral: 0.0)
        """
        self._set_channel_active_time(self._get_50hz_duty_cycle_from_percent(-value), self.pwm_controller,
                                      self.PWM_STEERING_CHANNEL)

    def set_throttle_percent(self, value: float) -> None:
        """Set the desired throttle value in percent. When the value changes from value>0 to value<0, the ESC
        interprets this as a brake command. To go backwards you have to go from value>0 to value=0 first, wait for
        a few moments (exact time is unknown) and afterwards to value<0 to go backwards.

       :param float value: Throttle in percent (forward: 0.0 to +1.0, backward/brake: 0.0 to -1.0, neutral: 0.0)
        """
        self._set_channel_active_time(self._get_50hz_duty_cycle_from_percent(value), self.pwm_controller,
                                      self.PWM_THROTTLE_CHANNEL)


class PiRacerStandard(PiRacerBase):
    """
    Provides access to the periphery of the PiRacer Standard model.
    """

    PWM_STEERING_CHANNEL = 0
    PWM_THROTTLE_CHANNEL_LEFT_MOTOR_IN1 = 5
    PWM_THROTTLE_CHANNEL_LEFT_MOTOR_IN2 = 6
    PWM_THROTTLE_CHANNEL_LEFT_MOTOR_PWM = 7
    PWM_THROTTLE_CHANNEL_RIGHT_MOTOR_IN1 = 1
    PWM_THROTTLE_CHANNEL_RIGHT_MOTOR_IN2 = 2
    PWM_THROTTLE_CHANNEL_RIGHT_MOTOR_PWM = 0

    def __init__(self) -> None:
        super().__init__()
        self.steering_pwm_controller = PCA9685(self.i2c_bus, address=0x40)
        self.steering_pwm_controller.frequency = self.PWM_FREQ_50HZ

        self.throttle_pwm_controller = PCA9685(self.i2c_bus, address=0x60)
        self.throttle_pwm_controller.frequency = self.PWM_FREQ_50HZ

        self.battery_monitor = INA219(self.i2c_bus, addr=0x41)

        self._warmup()

    def set_steering_percent(self, value: float) -> None:
        """Set the desired steering value in percent.

        :param float value: Steering angle in percent (left: 0.0 to -1.0, right: 0.0 to +1.0, neutral: 0.0)
        """
        self._set_channel_active_time(self._get_50hz_duty_cycle_from_percent(-value), self.steering_pwm_controller,
                                      self.PWM_STEERING_CHANNEL)
        pass

    def set_throttle_percent(self, value: float) -> None:
        """Set the desired throttle value in percent.

        :param float value: Throttle in percent (forward: 0.0 to +1.0, backward: 0.0 to -1.0, brake: 0.0)
        """
        if value > 0:
            self.throttle_pwm_controller.channels[self.PWM_THROTTLE_CHANNEL_LEFT_MOTOR_IN1].duty_cycle = self.PWM_MAX_RAW_VALUE
            self.throttle_pwm_controller.channels[self.PWM_THROTTLE_CHANNEL_LEFT_MOTOR_IN2].duty_cycle = 0

            self.throttle_pwm_controller.channels[self.PWM_THROTTLE_CHANNEL_RIGHT_MOTOR_IN1].duty_cycle = 0
            self.throttle_pwm_controller.channels[self.PWM_THROTTLE_CHANNEL_RIGHT_MOTOR_IN2].duty_cycle = self.PWM_MAX_RAW_VALUE
        else:
            self.throttle_pwm_controller.channels[self.PWM_THROTTLE_CHANNEL_LEFT_MOTOR_IN1].duty_cycle = 0
            self.throttle_pwm_controller.channels[self.PWM_THROTTLE_CHANNEL_LEFT_MOTOR_IN2].duty_cycle = self.PWM_MAX_RAW_VALUE

            self.throttle_pwm_controller.channels[self.PWM_THROTTLE_CHANNEL_RIGHT_MOTOR_IN1].duty_cycle = self.PWM_MAX_RAW_VALUE
            self.throttle_pwm_controller.channels[self.PWM_THROTTLE_CHANNEL_RIGHT_MOTOR_IN2].duty_cycle = 0

        pwm_raw_value = int(self.PWM_MAX_RAW_VALUE * abs(value))
        self.throttle_pwm_controller.channels[self.PWM_THROTTLE_CHANNEL_LEFT_MOTOR_PWM].duty_cycle = pwm_raw_value
        self.throttle_pwm_controller.channels[self.PWM_THROTTLE_CHANNEL_RIGHT_MOTOR_PWM].duty_cycle = pwm_raw_value
