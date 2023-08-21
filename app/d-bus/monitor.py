import time
from vehicles import PiRacerStandard
from battery_service import battery_service_process
from car_control import car_control
from dbus_service import dbus_service_process
from multiprocessing import Process

def restart_process(target, args, name):
    new_process = Process(target=target, args=args, name=name)
    new_process.start()
    return new_process

def monitor_thread(processes, piracer, shanwan_gamepad):
     while True:
        for p in processes:
            if not p.is_alive():
                print(f"Process {p.name} has terminated unexpectedly!")
                if p.name == 'python3_car_control':
                    piracer.set_steering_percent(0)
                    piracer.set_throttle_percent(0)
                    new_process = restart_process(target=car_control, args=(piracer, shanwan_gamepad), name=p.name)
                elif p.name == 'python3_battery_process':
                    new_process = restart_process(target=battery_service_process, args=(piracer,), name=p.name)
                elif p.name == 'python3_dbus_process':
                    new_process = restart_process(target=dbus_service_process, args=(), name=p.name)
                processes.remove(p)
                processes.append(new_process)
        time.sleep(1)
