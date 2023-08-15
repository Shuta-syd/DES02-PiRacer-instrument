import socket
import time
import queue

server_address = 'localhost'
server_port = 23513

def send_data(can_queue,car_info_queue,car_control_queue):

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
                        can_bus = can_queue.get_nowait()
                        car_info = car_info_queue.get_nowait()
                        car_control = car_control_queue.get_nowait()

                        speed = can_bus[0]
                        rpm =  can_bus[1]
                        ip_address = car_info[0]
                        battery_voltage = car_info[1]
                        battery_current =  car_info[2]
                        power_consumption = car_info[3]
                        curtime = car_info[4]
                        throttle = car_control[0]
                        steering = car_control[1]
                    except queue.Empty:
                        speed = 0
                        rpm = 0  
                        ip_address = ""
                        battery_voltage = 0
                        battery_current = 0
                        power_consumption = 0
                        curtime = 0
                        throttle = 0
                        steering = 0
                    # create message with speed and rpm and send it to client
                    message = f"{speed:.2f},{rpm:.2f},{ip_address},{battery_voltage:.2f},{battery_current:.2f},{power_consumption:.2f},{curtime},{throttle:.2f},{steering:.2f}\n"
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

