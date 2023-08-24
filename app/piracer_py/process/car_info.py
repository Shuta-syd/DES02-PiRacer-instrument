import os
import socket
import pathlib
from datetime import datetime
from   piracer.vehicles import PiRacerStandard
import queue
import time
import math 

FILE_DIR = pathlib.Path(os.path.abspath(os.path.dirname(__file__)))

#def car_info(vehicle: PiRacerStandard, q):
def car_info(q):

    piracer         = PiRacerStandard()             
 
    try:
        while True:
            # get time information
            now = datetime.now()
            curtime = now.strftime("%H:%M:%S")
        
            # get ip address
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)    # Create a socket object
                s.connect(("1.1.1.1", 1))                               # Connect to a non-existent external server
                local_ip_address = s.getsockname()[0]                   # Get the local IP address from the socket
                s.close()                                               # Close the socket
            except Exception as e:
                print("Error while getting local IP address:", e)

            # get & calc battery info
            num_cells               = 3                                 # number of cells
            battery_capacity         = num_cells*2600                   # in mAh
            battery_voltage          = round(piracer.get_battery_voltage(), 3)   # in V
            battery_current          = round(piracer.get_battery_current(), 3)   # in mA
            if battery_current < 0:                        
                battery_current = battery_current * (-1)                         #sometime the battery current is negative
            power_consumption        = round(piracer.get_power_consumption(), 3) # in W
        
            # approximation of battery level in % (third degree, approximation)
            x = battery_voltage / 3             # battery sanyo 18650 - number of cells: 3
            y = -691.919 * x**3 + 7991.667 * x**2 - 30541.295 * x + 38661.5 
            battery_level = int(y)
            if battery_level > 100:
                battery_level = 100

            # calculate battery hour in h, assuming that a fully charged battery can run for 4 hours
            battery_hour = round(4 * (battery_level/100), 3) # in h

            # display car info on onload oled screen (SSD1306_I2C)
            display      = piracer.get_display()                                                    
            # Clear display
            display.fill(0)                                                                            
            # Print first row - IP address
            display.text(f"IP: {local_ip_address}" , 0, 0,   'white', font_name=FILE_DIR/'fonts'/'font5x8.bin')   
            # Print second row
            display.text(f"Battery: {battery_level} % ", 0, 10,  'white', font_name=FILE_DIR/'fonts'/'font5x8.bin')   
            # Print third row
            display.text(f"{curtime}", 0, 20,  'white', font_name=FILE_DIR/'fonts'/'font5x8.bin')   
            # Show the updated display with both texts
            display.show()                                                                             

            #print(f"IP address: {local_ip_address} | Battery voltage: {battery_voltage} V | Power consumption: {power_consumption} W | Battery current: {battery_current} mA | Battery level: {battery_level} % | Battery hour: {battery_hour} h | Time: {curtime}")

            # put in queue
            try:
                q.put_nowait((local_ip_address, battery_voltage, power_consumption, battery_current, battery_level, battery_hour, curtime))
            except queue.Full:
                q.get()
                q.put((local_ip_address, battery_voltage, power_consumption, battery_current, battery_level, battery_hour, curtime))  

            # wait 1/4 second
            #time.sleep(1/4)

    except KeyboardInterrupt:
        print(" - Display carinfo process has been stopped. -")
        pass
                                                                                          

