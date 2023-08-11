import multiprocessing
import queue
from  multiprocessing                 import Process 
from    piracer.vehicles              import PiRacerStandard
from    piracer.gamepads              import ShanWanGamepad
from    process.display_carinfo       import display_carinfo
from    process.car_control           import car_control
from    process.recieve_data import recieve_data
from   process.send_data import send_data

if __name__ == '__main__':
    
    piracer         = PiRacerStandard()             
    shanwan_gamepad = ShanWanGamepad()

    try:      

        # Run display_carinfo() in a seperate process 
        display_carinfo_process = Process(target=display_carinfo, args=(piracer,))
        display_carinfo_process.start()


        # Run car_controll() in a seperate process 
        car_control_process = Process(target=car_control, args=(piracer, shanwan_gamepad))
        car_control_process.start()

        # Create a queue for data exchange recieve_data and send_data between processes
        queue_size = 10
        queue = multiprocessing.Queue(queue_size)

        # Run recieve_data() in a seperate process
        recieve_data_process = Process(target=recieve_data, args=(queue,))
        recieve_data_process.start()

        # Run send_data() in a seperate process 
        send_data_process = Process(target=send_data, args=(queue,))
        send_data_process.start()
        
        # Wait for the processes to finish
        display_carinfo_process.join()
        car_control_process.join()
        recieve_data_process.join()
        send_data_process.join()

    except KeyboardInterrupt:
        # Exit with cmd+c
        print(" - PiRacer_py has been stopped. - ")
        pass
