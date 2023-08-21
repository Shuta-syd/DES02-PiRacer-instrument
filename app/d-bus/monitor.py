import time

def monitor_processes(processes):
     while True:
        for p in processes:
            if not p.is_alive():
                print(f"Process {p.name} has terminated unexpectedly!")
        time.sleep(0.1)
