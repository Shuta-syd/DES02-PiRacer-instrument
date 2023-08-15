import socket
import time
import queue

server_address = 'localhost'
server_port = 23513

def send_data(q):

    # create socket server
    soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    soc.bind((server_address, server_port))
    soc.listen(1)
    #print(f"Listening on {server_address}:{server_port}")

    while True:
        try:
            # wait for connection from client, will block until connection arrives
            conn, addr = soc.accept() 
            print(f"Connection from {addr}")
            while True:
                    # while process runs, unload queue and save speed and rpm in variables
                    try:
                        s = q.get_nowait()
                        speed = s[0]
                        rpm =  s[1]
                    except queue.Empty:
                        speed = 0
                        rpm = 0  
                    # create message with speed and rpm and send it to client
                    message = f"{speed:.2f},{rpm:.2f}"
                    try:
                        conn.sendall(message.encode('utf-8'))
                        print(f"Timestamp: {int(time.time())}, tcp sent {message.strip()}")
                    except (BrokenPipeError, ConnectionResetError):
                        print("Client disconnected, waiting for another connection")
                        break
                    # send next message in 0.5s
                    time.sleep(0.5)
            conn.close()
        except BlockingIOError:
            # No connection yet, wait for a bit
            print("Waiting for connection")
            pass    
        except KeyboardInterrupt:
            # Exit with cmd+c
            print(" - Send_data process has been stopped. - ")
            # shut down the socket server
            soc.close()
            break
        except Exception as e:
            print(e)
            break
    soc.close()

