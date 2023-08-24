from piracer.vehicles import PiRacerStandard
from piracer.gamepads import ShanWanGamepad
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

            vehicle.set_steering_percent(-steering)
            vehicle.set_throttle_percent(throttle)

            # Indicator, depending on steering. 0 = off, 1 = left, 2 = right. 
            # Maybe we can use button_l1 and button_r1 for indicator
            if steering < 0:
                indicator = 1
            elif steering > 0:
                indicator = 2
            else:
                indicator = 0   

            #print(f'throttle={throttle}, steering={steering}, indicator={indicator}')

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
