import  os
import  socket
import  pathlib
from    datetime            import datetime
from    piracer.vehicles    import PiRacerStandard
import  queue
import  time 

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

            # get & calc battery info (battery sanyo 18650)
            num_cells                = 3                                              # number of cells
            battery_capacity         = num_cells*2600                                 # in mAh
            battery_voltage          = round(abs(piracer.get_battery_voltage()), 3)   # in V
            battery_current          = round(abs(piracer.get_battery_current()), 3)   # in mA
            power_consumption        = round(abs(piracer.get_power_consumption()), 3) # in W
        
            # approximation of battery level in % (third degree, approximation)
            x = battery_voltage / num_cells
            y = -691.919 * x**3 + 7991.667 * x**2 - 30541.295 * x + 38661.5 
            # make sure that battery level is between 0 and 100
            battery_level = min(max(round(y, 3), 0), 100) # in %

            # calculate battery hour in h, assuming that a fully charged battery can run for 4 hours
            battery_hour = round(4 * (battery_level/100), 3) # in h

            # refresh display every 0.25 seconds
            #if time.time() % 0.25 < 0.01:
                #display.fill(0)  # Clear display                                                                         
                #display.text(f"IP: {local_ip_address}" , 0, 0,   'white', font_name=FILE_DIR/'fonts'/'font5x8.bin')   
                #display.text(f"Battery: {battery_level} % ", 0, 10,  'white', font_name=FILE_DIR/'fonts'/'font5x8.bin')   
                #display.text(f"{curtime}", 0, 20,  'white', font_name=FILE_DIR/'fonts'/'font5x8.bin')   
                #display.show()                                          
                #print(f"IP address: {local_ip_address} | Battery voltage: {battery_voltage} V | Power consumption: {power_consumption} W | Battery current: {battery_current} mA | Battery level: {battery_level} % | Battery hour: {battery_hour} h | Time: {curtime}")

            # put in queue
            try:
                q.put_nowait((local_ip_address, battery_voltage, power_consumption, battery_current, battery_level, battery_hour, curtime))
            except queue.Full:
                q.get()
                q.put((local_ip_address, battery_voltage, power_consumption, battery_current, battery_level, battery_hour, curtime))  

    except KeyboardInterrupt:
        print("Display carinfo process has been stopped.")
        pass
                                                                                          

