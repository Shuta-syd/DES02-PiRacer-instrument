from piracer.vehicles import PiRacerStandard
from piracer.gamepads import ShanWanGamepad
import queue

def car_control(vehicle: PiRacerStandard, gamepad: ShanWanGamepad, q):
    try:
        while True:
            # read gamepad input
            gamepad_input = gamepad.read_data()
            # get throttle and steering value from gamepad
            throttle = gamepad_input.analog_stick_left.y
            steering = gamepad_input.analog_stick_left.x
            # drive car
            vehicle.set_throttle_percent(throttle)
            vehicle.set_steering_percent((-1)*steering)
            #print(f'throttle: {throttle}, steering: {steering}')

            # put gamepad input into queue
            try:
                q.put_nowait((throttle, steering))
            except queue.Full:
                q.get()
                q.put((throttle, steering))

    except KeyboardInterrupt:
        # Exit with cmd+c
        print(" - Car control process has been stopped. - ")
        # Reset drivetrain
        vehicle.set_steering_percent(0)
        vehicle.set_throttle_percent(0)
