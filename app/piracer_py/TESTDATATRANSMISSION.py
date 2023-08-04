import can
import time
import time
import socket
from queue import Queue


can_interface = 'can0'
server_address  ='localhost'	# 127.0.0.1 for loopback 
server_port 	= 23513 	# Duke Nukem 3D port

def main():
    try: 
        queue = Queue()
        # create a can bus instance
        bus = can.interface.Bus(channel=can_interface, bustype='socketcan')
        soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # connect to C++ server
        server = (server_address,server_port) 
        #soc.connect(server)
        while True:
            # Receive message from CAN bus
            message = bus.recv() 
            # Put message into queue
            print(message)
            queue.put(message.data[0])
            # get value from queue
            if (queue.empty()):
               print("NO DATA IN QUEUE")
            else: 
               value = queue.get()
               # Send data to C++ server
               #soc.senall(value.encode()
               print(f"SEND TO SOCKET:{value}")
            time.sleep(1)
    except KeyboardInterrupt:
        bus.shutdown()
        soc.close()
        
if __name__ == "__main__":
	main()
