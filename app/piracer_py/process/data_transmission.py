import can
import time
import time
import socket
import random
import math

can_interface       = 'can0'        # CAN interface
server_address      = 'localhost'
server_port 	    = 23513 	    # Duke Nukem 3D port
speedsensor_can_id  = 0x125      # CAN ID for speed sensor

def data_transmission():
    try:
        # create a can bus instance
        bus = can.interface.Bus(channel=can_interface, bustype='socketcan')
        # create a socket instance
        soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # bind to socket server
        soc.bind((server_address, server_port))
        soc.listen(1)
        print(f"Listening on {server_address}:{server_port}")

        while True:
            conn, addr = soc.accept()
            print(f"Connection from {addr}")
            while True:
                # Receive message from CAN bus
                message = bus.recv()
                send = 0
                if message is not None:
                    # Print CAN message
                    print(f"ID: {message.arbitration_id} DLC: {message.dlc} DATA: {message.data}")

                    # choose depending on sender ID
                    if message.arbitration_id == speedsensor_can_id:
                        # Interpret the data payload as a 16-bit unsigned integer (uint8_t data[8];) that holds an unsigned long value
                        receive = int.from_bytes(message.data, byteorder='big', signed=False)

                        # calculate speed [m/min] from RPM of the wheel and wheel circumference [mm]
                        WheelDiameter = 65.0  # [mm]
                        wheel_circumference = (WheelDiameter * math.pi) / 1000  # Wheel circumference [m]
                        RPM_wheel = receive
                        speed = RPM_wheel * wheel_circumference / 1000  # [m/min]

                        send = speed

                        # test data
                        rpm = random.randint(0, 500)
                        message_to_send = f"{send},{rpm}"

                        try:
                            conn.sendall(message_to_send.encode('utf-8'))
                            print(f"SEND TO SOCKET:{message_to_send}")
                        except (BrokenPipeError, ConnectionResetError):
                            print("Client disconnected, waiting for another connection")
                            break

                else:
                    # If no data received from CAN bus, send 0 to socket
                    print("No data received from CAN bus")

                # pause process for 0.5 seconds
                time.sleep(0.5)

    except KeyboardInterrupt:
        # Exit with cmd+c and close socket and can bus
        print(" - Data transmission process has been stopped. - ")
        bus.shutdown()
        soc.close()
