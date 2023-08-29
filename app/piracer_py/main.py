import  multiprocessing
from    multiprocessing         import Process 
import  threading
from setproctitle import setproctitle
import  sys
# Why this error:   File "/home/seame01/workspace/TCP-Version_DES02-PiRacer-instrument/DES02-PiRacer-instrument/app/piracer_py/main.py", line 4, in <module> from setproctitle import setproctitle ModuleNotFoundError: No module named 'setproctitle'
# Solution:         sudo apt-get install python3-setproctitle

from    process.car_info        import car_info
from    process.car_control     import car_control
from    process.recieve_data    import recieve_data
from    process.send_data       import send_data
from    monitor                  import monitor_thread

def terminate_processes(processes):
    for p in processes:
        p.terminate()

if __name__ == '__main__':
         
    # Create a queues for data exchange between processes. 
    queue_size = 10
    can_queue           = multiprocessing.Queue(queue_size)
    car_info_queue      = multiprocessing.Queue(queue_size)
    car_control_queue   = multiprocessing.Queue(queue_size)
    queues              = [can_queue, car_info_queue, car_control_queue]


    # set name of the main process
    setproctitle("python3_main_process")

    # Run seperate processes
    car_info_process = Process(target=car_info, args=(car_info_queue,))
    setproctitle("python3_car_info")
    car_info_process.start()

    car_control_process = Process(target=car_control, args=(car_control_queue,))
    setproctitle("python3_car_control")
    car_control_process.start()

    recieve_data_process = Process(target=recieve_data, args=(can_queue,))
    setproctitle("python3_recieve_data")
    recieve_data_process.start()

    send_data_process = Process(target=send_data, args=(can_queue,car_info_queue,car_control_queue))
    setproctitle("python3_send_data")
    send_data_process.start()
    
    # Monitor the processes and restart them if they crash
    processes   = [car_info_process, car_control_process, recieve_data_process, send_data_process]
    monitor_thread = threading.Thread(target=monitor_thread, args=(processes, queues,), name='monitor_thread')
    monitor_thread.start()

    try: 
        # Wait for the processes to finish
        car_control_process.join()
        car_info_process.join()
        recieve_data_process.join()
        send_data_process.join()

    # Exit with cmd+c
    except KeyboardInterrupt:         
        print(" - PiRacer_py has been stopped. - ")
        # Terminate all processes
        terminate_processes(processes)
        # Exit the program
        sys.exit(1)
