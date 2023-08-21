import time
from multiprocessing import Process

def monitor_thread(processes):
     while True:
        for p in processes:
            print(p)
            if not p.is_alive():
                print(f"Process {p.name} has terminated unexpectedly!")
        time.sleep(1)
