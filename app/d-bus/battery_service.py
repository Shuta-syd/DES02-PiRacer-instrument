from pydbus import SessionBus
from math import pi
from gi.repository import GLib
from   piracer.vehicles import PiRacerStandard


class BatteryService(object):
  """
      <node>
          <interface name='com.dbus.batteryService'>
              <method name='getConsumption'>
                  <arg type='i' name='response' direction='out'/>
              </method>
              <method name='getVoltage'>
                  <arg type='i' name='response' direction='out'/>
              </method>
              <method name='getCurrent'>
                <arg type='i' name='response' direction='out'/>
              </method>
          </interface>
      </node>
  """
  def __init__(self, vehicle):
    self._current = 0
    self._voltage = 0
    self._consumption = 0
    self._level = 0

  def getVoltage(self) -> int:
    battery_voltage          = round(vehicle.get_battery_voltage(),1) # in V
    return self._voltage

  def getSpeed(self) -> int:
    print("rpm: ", self._rpm);
    speed = self._rpm * wheel_circumference
    return speed

  def getBatteryInfo() -> tuple: # battery level, consumption,voltage, current
    level = 42
    voltage = _dbus_battery.getVoltage() # [V]
    consumption = _dbus_battery.getConsumption() # [""]
    current = _dbus_battery.getCurrent() # [mA]
    print(level, consumption, voltage, current)
    return level, consumption, voltage, current;

def battery_service_process(vehicle: PiRacerStandard):
  loop = GLib.MainLoop()
  bus = SessionBus()
  bus.publish("com.dbus.batteryService", DbusService(vehicle))
  loop.run();
