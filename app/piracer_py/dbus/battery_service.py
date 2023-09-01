from pydbus import SessionBus
from math import pi
from gi.repository import GLib
from system.vehicles import PiRacerStandard
from multiprocessing  import Queue

class BatteryService(object):
  """
      <node>
          <interface name='com.dbus.batteryService'>
              <method name='getLevel'>
                  <arg type='s' name='response' direction='out'/>
                  <arg type='s' name='response' direction='out'/>
              </method>
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
    self._current = 0.0
    self._voltage = 0.0
    self._consumption = 0.0
    self._level = 0.0
    self._hour = 0.0
    self._vehicle = vehicle

  def getLevel(self) -> list:
    num_cells = 3 # number of cells
    # approximation of battery level in % (third degree, approximation)
    x = self._voltage / num_cells
    y = -691.919 * x**3 + 7991.667 * x**2 - 30541.295 * x + 38661.5
    # make sure that battery level is between 0 and 100
    self._level = min(max(round(y, 3), 0), 100) # in %

    # calculate battery hour in h, assuming that a fully charged battery can run for 4 hours
    self._hour = round(4 * (self._level/100), 3) # in h

    level = str(self._level)
    hour = str(self._hour)
    return [level, hour]

  def getVoltage(self) -> str:
    _voltage          = round(abs(self._vehicle.get_battery_voltage()),3) # in V
    return str(_voltage)

  def getConsumption(self) -> str:
    _consumption      = round(abs(self._vehicle.get_power_consumption()), 3) # in W
    return str(_consumption)

  def getCurrent(self) -> str:
    _current = round(abs(self._vehicle.get_battery_current()), 3) # in mA
    return str(_current)

def battery_service_process(vehicle: PiRacerStandard, communication_queue: Queue):
  loop = GLib.MainLoop()
  bus = SessionBus()
  bus.publish("com.dbus.batteryService", BatteryService(vehicle))
  communication_queue.put('battery_service_process ready')
  loop.run();
