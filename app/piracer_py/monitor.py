import time
from multiprocessing        import Process
from setproctitle           import setproctitle
from process.car_control    import car_control
from process.car_info       import car_info
from process.recieve_data   import recieve_data
from process.send_data      import send_data

def restart_process(target, args, name):
    new_process = Process(target=target, args=args, name=name)
    new_process.start()
    return new_process

def monitor_thread(processes, queues):
     while True:
        for p in processes:

            # if p.is_alive():
            #     print(f"{p.name} is running.")

            if not p.is_alive():
                print(f"{p.name} has terminated unexpectedly!")

                if p.name == 'python3_car_info':
                #if p.name == 'Process-1':                    
                    q = queues[1]
                    new_process = restart_process(target=car_info, args=(q, ), name=p.name)
                    setproctitle("python3_car_info")

                if p.name == 'python3_car_control':
                #if p.name == 'Process-2':
                    q = queues[2]
                    new_process = restart_process(target=car_control, args=(q, ), name=p.name)
                    setproctitle("python3_car_control")

                if p.name == 'python3_recieve_data_process':
                #if p.name == 'Process-3':
                    q = queues[0]
                    new_process = restart_process(target=recieve_data, args=(q, ),  name=p.name)
                    setproctitle("python3_recieve_data_process")

                if p.name == 'python3_send_data_process':
                #if p.name == 'Process-4':
                    new_process = restart_process(target=send_data, args=(queues[0],queues[1],queues[2],), name=p.name)
                    setproctitle("python3_send_data_process")

                processes.remove(p)
                processes.append(new_process)

        time.sleep(1)