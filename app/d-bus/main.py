import time
from multiprocessing  import Process
from vehicles import PiRacerStandard
from  battery_service import battery_service_process
from car_control import car_control
from dbus_service import dbus_service_process
from gamepads import ShanWanGamepad

if __name__ == '__main__':
  piracer         = PiRacerStandard()
  shanwan_gamepad = ShanWanGamepad()

  car_control_process = Process(target=car_control, args=(piracer, shanwan_gamepad))
  car_control_process.start()

  battery_process = Process(target=battery_service_process, args=(piracer,))
  battery_process.start()

  dbus_process = Process(target=dbus_service_process)
  dbus_process.start()

  car_control_process.join()
  battery_process.join()
  dbus_process.join()
