from piracer.vehicles import PiRacerStandard
from piracer.gamepads import ShanWanGamepad

def car_control_thread(vehicle: PiRacerStandard, gamepad: ShanWanGamepad):
    try:
        while True:
            gamepad_input = gamepad.read_data()

            throttle = gamepad_input.analog_stick_left.y
            steering = gamepad_input.analog_stick_left.x

            vehicle.set_throttle_percent(throttle)
            vehicle.set_steering_percent(steering)

            print(f'throttle: {throttle}, steering: {steering}')
    except KeyboardInterrupt:
        vehicle.set_steering_percent(0)