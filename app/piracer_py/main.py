import time
import threading
from multiprocessing  import Process, Queue
from dbus.battery_service import battery_service_process
from dbus.dbus_service import dbus_service_process
from dbus.monitor import monitor_thread
from setproctitle import setproctitle
from system.display_carinfo import display_carinfo
from system.vehicles import PiRacerStandard
from system.car_control import car_control

def terminate_processes(processes):
    for p in processes:
        p.terminate()

if __name__ == '__main__':
  communication_queue = Queue()
  piracer = PiRacerStandard()

  display_carinfo_process = Process(target=display_carinfo, args=(), name='python3_car_info')
  setproctitle("python3_car_info")
  display_carinfo_process.start()

  car_control_process = Process(target=car_control, args=( ), name='python3_car_control')
  setproctitle("python3_car_control")
  car_control_process.start()

  battery_process = Process(target=battery_service_process, args=(piracer, communication_queue, ), name='python3_battery_process')
  setproctitle("python3_battery_process")
  battery_process.start()

  if (communication_queue.get() == 'battery_service_process ready'):
    print('battery_service_process ready')
    dbus_process = Process(target=dbus_service_process, name='python3_dbus_process')
    setproctitle("python3_dbus_process")
    dbus_process.start()

  processes = [car_control_process, battery_process, dbus_process]
  monitor_thread = threading.Thread(target=monitor_thread, args=(processes, piracer, communication_queue, ), name='monitor_thread')
  monitor_thread.start()

  setproctitle("python3_main_process")

  try:
    car_control_process.join()
    battery_process.join()
    dbus_process.join()
    monitor_thread.join()
  except KeyboardInterrupt:
    print("Ctrl + C detected. Terminating processes...")
    exit(1)
