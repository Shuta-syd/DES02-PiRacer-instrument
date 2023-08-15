import can
import  dbus
import dbus.service
from math import pi
import asyncio
from random import randint

can_interface = 'can0'
rpm_canId = 0x125 # 293 (decimal)
WheelDiameter = 65.0 # [mm]
wheel_circumference =  (WheelDiameter * pi) / 1000 # Wheel circumference [m]

bus = dbus.SessionBus()

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
    self._can = can.interface.Bus(channel=can_interface, bustype='socketcan')
    self._dbus = bus.get_object("com.test.canDataReceiver", "/com/test/canDataReceiver/data")

  async def getRpm(self) -> int:
    message = self.can.recv()
    if message is not None and message.arbitration_id == rpm_canId:
     rpm = int.from_bytes(message.data[:4], byteorder='little', signed=False)
     return rpm
    return 0

  async def getSpeed(self, rpm) -> int:
    speed = rpm * wheel_circumference
    return speed

  async def update(self):
    rpm = await self.getRpm()
    speed = await self.getSpeed()
    self._dbus.setData(speed, rpm)

async def main(handler):
  while 42:
    await handler.update()
    await asyncio.sleep(0.01)

obj = canDataReceiver();
bus.publish("com.test.canDataReceiver", obj);

if __name__ == '__main__':
  asyncio.run(main(obj))
