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

    piracer                 = PiRacerStandard() 
    power_consumption_queue = queue.Queue(maxsize=5) 
    battery_level_queue     = queue.Queue(maxsize=50) 
    display = piracer.get_display()
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
            battery_voltage          = round(abs(piracer.get_battery_voltage()), 3)   # in V
            battery_current          = round(abs(piracer.get_battery_current()), 3)   # in mA

            # moving average 
            power_consumption       = round(abs(battery_voltage * battery_current / 1000), 3) # in W  
            try: 
                power_consumption_queue.put_nowait(power_consumption)
            except queue.Full:
                power_consumption_queue.get()
                power_consumption_queue.put(power_consumption)
            power_consumption_list = list(power_consumption_queue.queue)
            power_consumption = round(sum(power_consumption_list)/len(power_consumption_list), 3)

            # approximation of battery level in % (third degree, approximation)
            x = battery_voltage / num_cells
            y = -691.919 * x**3 + 7991.667 * x**2 - 30541.295 * x + 38661.5 
            # make sure that battery level is between 0 and 100
            battery_level = min(max(round(y, 3), 0), 100) # in %
            # moving average 
            try: 
                battery_level_queue.put_nowait(battery_level)
            except queue.Full:
                battery_level_queue.get()
                battery_level_queue.put(battery_level)
            # calculate average power consumption in W
            battery_level_list = list(battery_level_queue.queue)
            battery_level = round(sum(battery_level_list)/len(battery_level_list), 3)

            # calculate battery hour in h, assuming that a fully charged battery can run for 4 hours
            battery_hour = round(4 * (battery_level/100), 3) # in h

            # put in queue
            try:
                q.put_nowait((local_ip_address, battery_voltage, power_consumption, battery_current, battery_level, battery_hour, curtime))
            except queue.Full:
                q.get()
                q.put((local_ip_address, battery_voltage, power_consumption, battery_current, battery_level, battery_hour, curtime))  

            display.fill(0)  # Clear display                                                                         
            display.text(f"IP: {local_ip_address}" , 0, 0,   'white', font_name=FILE_DIR/'fonts'/'font5x8.bin')   
            display.text(f"Battery: {battery_level} % ", 0, 10,  'white', font_name=FILE_DIR/'fonts'/'font5x8.bin')   
            display.text(f"{curtime}", 0, 20,  'white', font_name=FILE_DIR/'fonts'/'font5x8.bin')   
            display.show() 

    except KeyboardInterrupt:
        print("Display carinfo process has been stopped.")
        pass
                                                                                          

