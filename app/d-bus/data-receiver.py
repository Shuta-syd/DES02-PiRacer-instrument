#!/usr/bin/python3

import can
import pydbus
from gi.repository import GLib

can_interface = 'can0'
rpm_canId = 0x125 # 293 (decimal)

class canDataReceiver:
  """
      <node>
          <interface name='com.example.d-bus'>
              <method name='getRpm'>
                  <arg type='f' name='input' direction='in'/>
                  <arg type='f' name='response' direction='out'/>
              </method>
          </interface>
      </node>
  """
  def __init__(self):
    self.can = can.interface.Bus(channel=can_interface, bustype='socketcan')

  def getRpm():
    message = can.recv()
    if message is not None and message.arbitration_id == rpm_canId:
      rpm = int.from_bytes(message.data[:4], byteorder='little', signed=False)
      return rpm

bus = SessionBus()
bus.publish("com.example.d-bus", canDataReceiver())
GLib.MainLoop().run()
