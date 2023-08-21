import time
from multiprocessing import Process

def restart_process(target, args, name):
    new_process = Process(target=target, args=args, name=name)
    new_process.start()
    return new_process

def monitor_thread(processes, piracer):
     while True:
        for p in processes:
            if not p.is_alive():
                print(f"Process {p.name} has terminated unexpectedly!")
                if p.name == 'python3_car_control':
                    piracer.set_steering_percent(0)
                    piracer.set_throttle_percent(0)
                new_process = restart_process(p._target, p._args, p.name)
                processes.remove(p)
                processes.append(new_process)
        time.sleep(1)
