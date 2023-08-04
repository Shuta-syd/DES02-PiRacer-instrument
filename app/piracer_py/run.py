import  time
import  threading
from queue import Queue
from    piracer.vehicles                        import PiRacerStandard
from    piracer.gamepads                        import ShanWanGamepad
from    threads.display_carinfo_thread          import display_carinfo_thread
from    threads.car_control_thread              import car_control_thread
from    threads.receive_can_messages_thread     import receive_can_messages_thread
from 	threads.send_data_socket_thread		import send_data_socket_thread

if __name__ == '__main__':
    
    piracer         = PiRacerStandard()             
    shanwan_gamepad = ShanWanGamepad()
    #create a FIFO queue to share data between threads
    queue = Queue()
    
    try:      

        # Run "carinfo@oled" thread
        car_control          = threading.Thread(target=car_control_thread, args=(piracer, shanwan_gamepad))
        car_control.daemon   = True
        car_control.start()     

        # Run "car control" thread
        display_carinfo             = threading.Thread(target=display_carinfo_thread, args=(piracer,))
        display_carinfo.daemon      = True
        display_carinfo.start()

        # Run "read can message" thread
        receive_can_messages           = threading.Thread(target=receive_can_messages_thread, args=(queue,))
        receive_can_messages.daemon    = True
        receive_can_messages.start()      

        # Run "send data @ socket" thread
        send_data_socket            = threading.Thread(target=send_data_socket_thread, args=(queue,))
        send_data_socket.daemon     = True
        send_data_socket.start()   

        send_data_socket.join()
        receive_can_messages.join()
        display_carinfo.join()
        car_control.join()


        while True:
            # Ensure the main thread doesn't exit and keeps running indefinitely
            time.sleep(1)

    except KeyboardInterrupt:
        # Exit with Cmd+C
        print(" - Programm has been stopped. - ")
