import time
from multiprocessing import Process

def monitor_thread(processes, piracer):
     while True:
        for p in processes:
            if not p.is_alive():
                print(f"Process {p.name} has terminated unexpectedly!")
                if p.name is 'python3_car_control':
                    piracer.set_steering_percent(0)
                    piracer.set_throttle_percent(0)
        time.sleep(1)
