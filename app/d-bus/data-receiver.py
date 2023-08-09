import can
import pydbus
from gi.repository import GLib

can_interface = 'can0'
rpm_canId = 0x125 # 293 (decimal)

class canDataReceiver(object):
  """
      <node>
          <interface name='com.test.canDataReceiver'>
              <method name='getRpm'>
                  <arg type='i' name='response' direction='out'/>
              </method>
          </interface>
      </node>
  """
  def __init__(self):
    self.can = can.interface.Bus(channel=can_interface, bustype='socketcan')

  def getRpm(self) -> int:
    message = self.can.recv()
    print(message)
    if message is not None and message.arbitration_id == rpm_canId:
      rpm = int.from_bytes(message.data[:4], byteorder='little', signed=False)
      print(rpm)
      return rpm

bus = pydbus.SessionBus()
bus.publish("com.test.canDataReceiver", canDataReceiver())
GLib.MainLoop().run()
