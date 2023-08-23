import can
from pydbus import SessionBus
from math import pi
from gi.repository import GLib

can_interface = 'can1'
rpm_canId = 0x125 # 293 (decimal)
WheelDiameter = 65.0 # [mm]
wheel_circumference =  (WheelDiameter * pi) / 1000 # Wheel circumference [m]

class DbusService(object):
  """
      <node>
          <interface name='com.test.dbusService'>
              <method name='getRpm'>
                  <arg type='i' name='response' direction='out'/>
              </method>
              <method name='getSpeed'>
                  <arg type='i' name='response' direction='out'/>
              </method>
              <method name='getBatteryInfo'>
                <arg type='s' name='level' direction='out'/>
                <arg type='s' name='consumption' direction='out'/>
                <arg type='s' name='voltage' direction='out'/>
                <arg type='s' name='current' direction='out'/>
              </method>
          </interface>
      </node>
  """
  def __init__(self):
    self._can = can.interface.Bus(channel=can_interface, bustype='socketcan')
    self._dbus_battery = SessionBus().get('com.dbus.batteryService')
    self._rpm = 0

  def getRpm(self) -> int:
    message = self._can.recv()
    if message is not None and message.arbitration_id == rpm_canId:
      rpm = int.from_bytes(message.data[:2], byteorder='little', signed=False)
      self._rpm = rpm
      return rpm
    return 0

  def getSpeed(self) -> int:
    speed = self._rpm * wheel_circumference
    return speed

  def getBatteryInfo(self) -> tuple:
    level = "42"
    voltage = self._dbus_battery.getVoltage() # [V]
    consumption = self._dbus_battery.getConsumption() # [""]
    current = self._dbus_battery.getCurrent() # [mA]
    # print(level, consumption, voltage, current)
    return [level, consumption, voltage, current]  # battery level, consumption,voltage, current

def dbus_service_process():
  loop = GLib.MainLoop()
  bus = SessionBus()
  bus.publish("com.test.dbusService", DbusService())
  loop.run();
