import can
import time
import time
import socket
from queue import Queue
import random


can_interface = 'can0'
server_address  ='localhost'	# 127.0.0.1 for loopback 
server_port 	= 23513 	# Duke Nukem 3D port

def data_transmission():
    try: 
        #create queue 
        queue = Queue()
        # create a can bus instance
        bus = can.interface.Bus(channel=can_interface, bustype='socketcan')
        # create a socket instance
        soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # connect to socket server
        # soc.connect(server_address,server_port)
        while True:
            # Receive message from CAN bus
            message = bus.recv() 
            # Print CAN message
            #print all messages data from can bus
            print(f"ID: {message.arbitration_id} DLC: {message.dlc} DATA: {message.data}")
            # extract values from message.data
            for i in range(0, len(message.data)):
                print(f"MESSAGE.DATA[{i}]: {message.data[i]}")
            # load all message from CAN bus to FIFO queue
            #for i in range(0, len(message.data)): 
            #    queue.put(message.data[i])
            # put first element of message to queue 
            # queue.put(message.data[0])
            queue.put(random.randint(0, 255))
            # get value from queue, if queue is not empty send data to socket
            if (queue.empty()):
               print("NO DATA IN QUEUE")
            else: 
               # get value from FIFO queue and send to socket
            #    for i in range(0, len(message.data)):
            #     value = queue.get()
            #     # send data to socket
            #     soc.sendall(value.encode())
            #     print(f"(SEND TO SOCKET:{value}")
               value = queue.get()
               # Send data to socket
               #soc.senall(value.encode()
               print(f"SEND TO SOCKET:{value}")
            #pause process for 1 second
            time.sleep(1)
    except KeyboardInterrupt:
        # Exit with cmd+c and close socket and can bus
        print(" - Data transmission process has been stopped. - ")
        bus.shutdown()
        soc.close()
        
