import can
from pydbus import SessionBus
from gi.repository import GLib
from math import pi

can_interface = 'can0'
rpm_canId = 0x125 # 293 (decimal)
WheelDiameter = 65.0 # [mm]
wheel_circumference =  (WheelDiameter * pi) / 1000 # Wheel circumference [m]

class canDataReceiver(object):
  """
      <node>
          <interface name='com.test.canDataReceiver'>
              <method name='getRpm'>
                  <arg type='i' name='response' direction='out'/>
              </method>
              <method name='getSpeed'>
                  <arg type='i' name='input' direction='in'/>
                  <arg type='i' name='response' direction='out'/>
              </method>
          </interface>
      </node>
  """
  def __init__(self):
    self.can = can.interface.Bus(channel=can_interface, bustype='socketcan')

  def getRpm(self) -> int:
    message = self.can.recv()
    if message is not None and message.arbitration_id == rpm_canId:
      rpm = int.from_bytes(message.data[:4], byteorder='little', signed=False)
      return rpm
    return 0

  def getSpeed(self, rpm) -> int:
    speed = rpm * wheel_circumference
    return speed


bus = SessionBus()
bus.publish("com.test.canDataReceiver", canDataReceiver())
GLib.MainLoop().run()