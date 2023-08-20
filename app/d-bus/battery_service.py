from pydbus import SessionBus
from math import pi
from gi.repository import GLib

class BatteryService(object):
  """
      <node>
          <interface name='com.dbus.batteryService'>
              <method name='getConsumption'>
                  <arg type='s' name='response' direction='out'/>
              </method>
              <method name='getVoltage'>
                  <arg type='s' name='response' direction='out'/>
              </method>
              <method name='getCurrent'>
                <arg type='s' name='response' direction='out'/>
              </method>
          </interface>
      </node>
  """
  def __init__(self, vehicle):
    self._current = ''
    self._voltage = ''
    self._consumption = ''
    self._level = ''
    self._vehicle = vehicle

  def getVoltage(self) -> str:
    _voltage          = str(round(self._vehicle.get_battery_voltage(),1)) # in V
    return _voltage

  def getConsumption(self) -> str:
    _consumption      = str(round(self._vehicle.get_power_consumption(),1)) # in W
    return _consumption

  def getCurrent(self) -> str:
    _current = str(round(self._vehicle.get_battery_current(),1)) # in mA
    return _current

def battery_service_process(vehicle):
  loop = GLib.MainLoop()
  bus = SessionBus()
  bus.publish("com.dbus.batteryService", BatteryService(vehicle))
  loop.run();
