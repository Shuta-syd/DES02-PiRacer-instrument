from pydbus import SessionBus
from math import pi
from gi.repository import GLib

class BatteryService(object):
  """
      <node>
          <interface name='com.dbus.batteryService'>
              <method name='getConsumption'>
                  <arg type='f' name='response' direction='out'/>
              </method>
              <method name='getVoltage'>
                  <arg type='f' name='response' direction='out'/>
              </method>
              <method name='getCurrent'>
                <arg type='f' name='response' direction='out'/>
              </method>
          </interface>
      </node>
  """
  def __init__(self, vehicle):
    self._current = 0
    self._voltage = 0
    self._consumption = 0
    self._level = 0
    self._vehicle = vehicle

  def getVoltage(self) -> float:
    _voltage          = round(_vehicle.get_battery_voltage(),1) # in V
    return _voltage

  def getConsumption(self) -> float:
    _consumption      = round(_vehicle.get_power_consumption(),1) # in W
    return _consumption

  def getCurrent(self) -> float:
    _current = round(_vehicle.get_battery_current(),1) # in mA
    return _current

def battery_service_process(vehicle: PiRacerStandard):
  loop = GLib.MainLoop()
  bus = SessionBus()
  bus.publish("com.dbus.batteryService", BatteryService(vehicle))
  loop.run();
