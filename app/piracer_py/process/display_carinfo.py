import os
import time
import socket
import pathlib
from datetime import datetime
from   piracer.vehicles import PiRacerStandard
import queue

FILE_DIR = pathlib.Path(os.path.abspath(os.path.dirname(__file__)))

def display_carinfo(vehicle: PiRacerStandard, q):

    def get_current_time():
        now = datetime.now()
        current_time = now.strftime("%H:%M:%S")
        return current_time
    
    def get_battery_txt_info(vehicle: PiRacerStandard):
        battery_voltage          = round(vehicle.get_battery_voltage(),1) # in V 
        battery_current          = round(vehicle.get_battery_current(),1) # in mA
        power_consumption        = round(vehicle.get_power_consumption(),1) # in W
        batterylevel_info = f'{battery_voltage}V,{battery_current}mA,{power_consumption}W'
        return batterylevel_info

    def get_ip_address():
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)    # Create a socket object
            s.connect(("1.1.1.1", 1))                               # Connect to a non-existent external server
            local_ip_address = s.getsockname()[0]                   # Get the local IP address from the socket
            s.close()                                               # Close the socket
            return local_ip_address
        except Exception as e:
            print("Error while getting local IP address:", e)
            return None
    
    def display_carinfo(currenttime, ipAddress, batterylevel, vehicle: PiRacerStandard):
        ipAddress    = f'IP:{ipAddress}' 
        display      = vehicle.get_display()                                                       # Get SSD1306_I2C object 
        display.fill(0)                                                                            # Clear display
        display.text(batterylevel   , 0, 0,   'white', font_name=FILE_DIR/'fonts'/'font5x8.bin')   # Print first row 
        display.text(ipAddress      , 0, 10,  'white', font_name=FILE_DIR/'fonts'/'font5x8.bin')   # Print second row
        display.text(currenttime    , 0, 20,  'white', font_name=FILE_DIR/'fonts'/'font5x8.bin')   # 
        display.show()                                                                             # Show the updated display with both texts
    try:
        while True:
            ipAddr  = get_ip_address()                                                              
            bat_txt  = get_battery_txt_info(vehicle)
            curtime = get_current_time()
            # 
            display_carinfo(currenttime=curtime , ipAddress=ipAddr, batterylevel=bat_txt, vehicle=vehicle)
            # get battery info
            battery_voltage          = vehicle.get_battery_voltage()    # in V
            battery_current          = vehicle.get_battery_current()    # in mA
            power_consumption        = vehicle.get_power_consumption()  # in W
            battery_capacity         = 3*2600                           # in mAh 
            # put in queue
            try:
                q.put_nowait((ipAddr, battery_voltage, battery_current, power_consumption, curtime))
            except queue.Full:
                q.get()
                q.put((ipAddr, battery_voltage, battery_current, power_consumption, curtime))
            time.sleep(1)                                                                                 
    except KeyboardInterrupt:
        print(" - Display carinfo process has been stopped. -")
        pass