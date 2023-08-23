from .vehicles import PiRacerStandard
from .gamepads import ShanWanGamepad

def car_control(vehicle: PiRacerStandard):
    gamepad = ShanWanGamepad()
    try:
        while True:
            # read gamepad input
            gamepad_input = gamepad.read_data()
            # get throttle and steering value from gamepad
            throttle = gamepad_input.analog_stick_left.y
            steering = gamepad_input.analog_stick_left.x
            # drive car
            vehicle.set_throttle_percent(throttle)
            vehicle.set_steering_percent(-steering)

            #print(f'throttle: {throttle}, steering: {steering}')
    except KeyboardInterrupt:
        vehicle.set_steering_percent(0)
        vehicle.set_throttle_percent(0)
