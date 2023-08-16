import multiprocessing
import queue
from  multiprocessing                 import Process 
from    piracer.vehicles              import PiRacerStandard
from    piracer.gamepads              import ShanWanGamepad
from    process.car_info       import car_info
from    process.car_control           import car_control
from    process.recieve_data import recieve_data
from   process.send_data import send_data

if __name__ == '__main__':
    
    piracer         = PiRacerStandard()             
    shanwan_gamepad = ShanWanGamepad()

    try:      
        # Create a queues for data exchange between processes. 
        queue_size = 10
        can_queue           = multiprocessing.Queue(queue_size)
        car_info_queue      = multiprocessing.Queue(queue_size)
        car_control_queue   = multiprocessing.Queue(queue_size)

        # Run car_info() in a seperate process 
        car_info_process = Process(target=car_info, args=(piracer,car_info_queue))
        car_info_process.start()

        # Run car_controll() in a seperate process 
        car_control_process = Process(target=car_control, args=(piracer, shanwan_gamepad, car_control_queue))
        car_control_process.start()

        # Run recieve_data() in a seperate process
        recieve_data_process = Process(target=recieve_data, args=(can_queue,))
        recieve_data_process.start()

        # Run send_data() in a seperate process 
        send_data_process = Process(target=send_data, args=(can_queue,car_info_queue,car_control_queue))
        send_data_process.start()
        
        # Wait for the processes to finish
        car_info_process.join()
        car_control_process.join()
        recieve_data_process.join()
        send_data_process.join()

    except KeyboardInterrupt:
        # Exit with cmd+c
        print(" - PiRacer_py has been stopped. - ")
        pass
