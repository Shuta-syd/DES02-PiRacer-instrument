import socket
import time
import queue
import json

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
                    try:
                        # get last message from queues 
                        can_bus         = can_queue.get_nowait()
                        car_info        = car_info_queue.get_nowait()
                        car_control     = car_control_queue.get_nowait()
                        # unpack queues to create a message to send to client
                        throttle        = car_control[0]
                        steering        = car_control[1]
                        indicator       = car_control[2]        # int, 0=nothing,1=left,2=right,3=warning light, not availible yet
                        battery_voltage     = car_info[1]       # float, in V
                        power_consumption   = car_info[2]       # float, in W
                        battery_current     = car_info[3]       # float, in mA
                        battery_level       = car_info[5]       # float, in %
                        battery_hour        = car_info[6]       # float, in hour
                        speed           = can_bus[0]
                        rpm             = can_bus[1]
                        ip_address          = car_info[0]       # string, "1.1.1.1"        
                        curtime             = car_info[4]       # string, "00:00:00"
                        # create a dict to store all data
                        data = {
                            "throttle": throttle,
                            "steering": steering,
                            "indicator": indicator,
                            "battery_voltage": battery_voltage,
                            "power_consumption": power_consumption,
                            "battery_current": battery_current,
                            "battery_level": battery_level,
                            "battery_hour": battery_hour,
                            "speed": speed,
                            "rpm": rpm,
                            "ip_address": ip_address,
                            "curtime": curtime
                        }

                    except queue.Empty:
                        # if queue is empty, send empty message
                        # message = f",,,,,,,\n"
                        # if queue is empty, create a dict with empty data
                        data = {
                            "throttle": "",
                            "steering": "",
                            "indicator": "",
                            "battery_voltage": "",
                            "power_consumption": "",
                            "battery_current": "",
                            "battery_level": "",
                            "battery_hour": "",
                            "speed": "",
                            "rpm": "",
                            "ip_address": "",
                            "curtime": ""
                        }

                    # create a string message 
                    # message = f"{throttle},{steering},{indicator},{battery_voltage},{power_consumption},{battery_current},{battery_level},{battery_hour},{speed},{rpm},{ip_address},{curtime}\n"
                    
                    # create a json message 
                    message = json.dumps(data)

                    # send message to client
                    try:
                        #send message to client (should work for json and string)
                        conn.sendall(message.encode('utf-8'))
                        # print message to console
                        #print(f"Timestamp: {int(time.time())}, tcp sent {message}")

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

