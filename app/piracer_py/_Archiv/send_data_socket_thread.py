import time
import socket 

server_address  ='localhost'	# 127.0.0.1 for loopback 
server_port 	= 23513 	# Duke Nukem 3D port

def send_data_socket_thread(queue):

    try: 
        # create a socket
        soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # connect to C++ server
        server = (server_address,server_port) 
        #soc.connect(server)
        while True:
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
        soc.close()
