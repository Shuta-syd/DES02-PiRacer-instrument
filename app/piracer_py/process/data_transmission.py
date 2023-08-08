import can
import time
import time
import socket
import random
import math

can_interface   = 'can0'        # CAN interface
server_address  = 'localhost'
server_port 	= 23513 	    # Duke Nukem 3D port
speedsensor_can_id = 0x125      # CAN ID for speed sensor

def data_transmission():
    try:
        # create a can bus instance
        bus = can.interface.Bus(channel=can_interface, bustype='socketcan')
        # create a socket instance
        soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # connect to socket server
        # soc.connect(server_address,server_port)
        while True:
            # Receive message from CAN bus
            message = bus.recv()
            if message is not None:
                # Print CAN message
                print(f"ID: {message.arbitration_id} DLC: {message.dlc} DATA: {message.data}")

                #choose depending on sender ID
                if message.arbitration_id == speedsensor_can_id:

                    # Interpret the data payload as a 16-bit unsigned integer (uint8_t data[8];) that holds a usigned long value
                    recieve = int.from_bytes(message.data, byteorder='big', signed=False)
                    # recieve = int.from_bytes(message.data[:4], byteorder='little', signed=False)

                    # calculate speed [m/min] from RPM of the wheel and wheel circumference [mm]
                    WheelDiameter = 65.0 # [mm]
                    wheel_circumference =  (WheelDiameter * math.pi)/1000 # Wheel circumference [m]
                    RPM_wheel = recieve
                    speed = RPM_wheel * wheel_circumference / 1000 # [m/min]

                    send = speed

                    # test data
                    send = random.randint(0, 255)
            else:
                # If no data received from CAN bus, send 0 to socket
                send = 0
                print("No data received from CAN bus")

            # Send data to socket
            #soc.senall(send)
            print(f"SEND TO SOCKET:{send}")

            #pause process for 0.5 seconds
            time.sleep(0.5)

    except KeyboardInterrupt:

        # Exit with cmd+c and close socket and can bus
        print(" - Data transmission process has been stopped. - ")
        bus.shutdown()
        soc.close()
