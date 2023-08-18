import time
from multiprocessing  import Process
from piracer.vehicles import PiRacerStandard
from  battery_service import battery_service_process
from dbus_service import dbus_service_process

if __name__ == '__main__':
  piracer         = PiRacerStandard()
  shanwan_gamepad = ShanWanGamepad()

  car_control_process = Process(target=car_control, args=(piracer, shanwan_gamepad))
  car_control_process.start()

  battery_process = Process(target=battery_service_process, args=piracer)
  battery_process.start()

  dbus_process = Process(target=dbus_process)
  dbus_process.start()

  battery_process.join()
  dbus_process.join()
