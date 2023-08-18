from piracer.vehicles import PiRacerStandard
from piracer.gamepads import ShanWanGamepad
import piracer.gamepads
import queue
import traceback

#def car_control(vehicle: PiRacerStandard, gamepad: ShanWanGamepad, q):
def car_control(q):

    gamepad = ShanWanGamepad()
    vehicle = PiRacerStandard()

    try:
        while True:
            gamepad_input = gamepad.read_data()

            throttle = gamepad_input.analog_stick_left.y 
            steering = gamepad_input.analog_stick_left.x

            #print(f'throttle={throttle}, steering={steering}')

            vehicle.set_steering_percent(-steering)
            vehicle.set_throttle_percent(throttle)

            #get left and right shoulder button input for indicator
            # button_l1_state  = gamepad_input.button_l1
            # button_r1_state = gamepad_input.button_r1
            # warning_lights        = gamepad_input.button_home
            # print("button_r1 state:", button_r1_state)

            # # 0 = off, 1 = left, 2 = right
            indicator = 0 
            # if button_l1_state:
            #     indicator = 1
            # elif button_r1_state:
            #     indicator = 2
            # elif warning_lights:
            #     indicator = 3

            #put gamepad input into queue
            throttle = round(throttle, 3)
            steering = round(steering, 3)
            
            try:
                q.put_nowait((throttle, steering, indicator))
            except queue.Full:
                q.get()
                q.put((throttle, steering, indicator))

    except Exception as e:
        print(" - Car control process has been stopped. - ")
        print("An error occurred:", e)     
        # dipslay the full error message
        traceback.print_exc()

        # Reset drivetrain
        vehicle.set_steering_percent(0)
        vehicle.set_throttle_percent(0)

    except KeyboardInterrupt:
        # Exit with cmd+c
        print(" - Car control process has been stopped. - ")
        
        # Reset drivetrain
        vehicle.set_steering_percent(0)
        vehicle.set_throttle_percent(0)
