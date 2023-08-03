import  time
import  threading
import 	queue
from    piracer.vehicles                        import PiRacerStandard
from    piracer.gamepads                        import ShanWanGamepad
from    threads.display_carinfo_thread          import display_carinfo_thread
from    threads.car_control_thread              import car_control_thread
from    threads.receive_can_messages_thread     import receive_can_messages_thread
from 	threads.send_data_socket_thread		import send_data_socket_thread

if __name__ == '__main__':
    
    piracer         = PiRacerStandard()             
    shanwan_gamepad = ShanWanGamepad()
    shared_queue    = queue.Queue() 		# Queue to store (CAN-Bus) values to and transfer between threads 
    
    try:      

        # Run carinfo@oled thread
        car_control_thread          = threading.Thread(target=car_control_thread, args=(piracer, shanwan_gamepad))
        car_control_thread.daemon   = True
        car_control_thread.start()     

        # Run car control thread
        car_info_thread             = threading.Thread(target=display_carinfo_thread, args=(piracer,))
        car_info_thread.daemon      = True
        car_info_thread.start()

        # Run read can message thread
        receive_can_messages_thread           = threading.Thread(target=receive_can_messages_thread, args=(queue,))
        receive_can_messages_thread.daemon    = True
        receive_can_messages_thread.start()      

        # Run send data @ socket thread
        car_control_thread          = threading.Thread(target=send_data_socket_thread, args=(queue,))
        car_control_thread.daemon   = True
        car_control_thread.start()     

        while True:
            # Ensure the main thread doesn't exit and keeps running indefinitely
            time.sleep(1)

    except KeyboardInterrupt:

        # Cmd+C (MacOs😄)
        print("Programm has been stopped.")
