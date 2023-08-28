import time
import threading
from multiprocessing  import Process
from vehicles import PiRacerStandard
from battery_service import battery_service_process
from car_control import car_control
from dbus_service import dbus_service_process
from monitor import monitor_thread
from gamepads import ShanWanGamepad
from setproctitle import setproctitle

def terminate_processes(processes):
    for p in processes:
        p.terminate()

if __name__ == '__main__':
  piracer         = PiRacerStandard()
  shanwan_gamepad = ShanWanGamepad()

  car_control_process = Process(target=car_control, args=(piracer, shanwan_gamepad), name='python3_car_control')
  setproctitle("python3_car_control")
  car_control_process.start()

  battery_process = Process(target=battery_service_process, args=(piracer,), name='python3_battery_process')
  setproctitle("python3_battery_process")
  battery_process.start()

  dbus_process = Process(target=dbus_service_process, name='python3_dbus_process')
  setproctitle("python3_dbus_process")
  dbus_process.start()

  processes = [car_control_process, battery_process, dbus_process]
  monitor_thread = threading.Thread(target=monitor_thread, args=(processes, piracer, shanwan_gamepad), name='monitor_thread')
  monitor_thread.start()

  setproctitle("python3_main_process")

  try:
    car_control_process.join()
    battery_process.join()
    dbus_process.join()
  except KeyboardInterrupt:
    print("Ctrl + C detected. Terminating processes...")
    terminate_processes(processes)