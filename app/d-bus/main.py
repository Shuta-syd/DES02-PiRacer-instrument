import time
from multiprocessing  import Process
from vehicles import PiRacerStandard
from battery_service import battery_service_process
from car_control import car_control
from dbus_service import dbus_service_process
from gamepads import ShanWanGamepad
from monitor import monitor_processes

if __name__ == '__main__':
  piracer         = PiRacerStandard()
  shanwan_gamepad = ShanWanGamepad()

  car_control_process = Process(target=car_control, args=(piracer, shanwan_gamepad), name='python3_car_control')
  car_control_process.start()

  battery_process = Process(target=battery_service_process, args=(piracer,), name='python3_batter_process')
  battery_process.start()

  dbus_process = Process(target=dbus_service_process, name='python3_dbus_process')
  dbus_process.start()

  processes = [car_control, battery_process, dbus_process]
  monitoring_process = Process(target=monitor_processes, args=(processes,), name='python3_monitor_process')
  monitoring_process.start()

  car_control_process.join()
  battery_process.join()
  dbus_process.join()
  monitoring_process.join()
