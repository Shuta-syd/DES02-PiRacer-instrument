import socket
import time
import queue
import json

server_address = "localhost"
server_port = 23513

def send_data(can_queue,car_info_queue,car_control_queue):

    # create socket server
    soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    soc.bind((server_address, server_port))
    soc.listen(1)
    print(f"TCP Server online. Listening on: {server_address}:{server_port}")

    while True:

        #create a shallow copy of the queues
        copy_can_queue           = can_queue
        copy_car_info_queue      = car_info_queue
        copy_car_control_queue   = car_control_queue

        try:
            # wait for connection from client, will block until connection arrives
            conn, addr = soc.accept() 
            print(f"Connection from {addr}")
            
            while True:
                    
                    # create default dict with names but no data
                    data = {
                        "throttle": "0",
                        "steering": "0",
                        "indicator": "0",
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

                    # get last message from can_queue. 
                    # If not empty get can info and save in data dict.
                    # If queue is empty, print message and use default dict
                    try: 
                        can_bus         = copy_can_queue.get_nowait()
                        speed           = can_bus[0]
                        rpm             = can_bus[1]
                        data["speed"]   = speed
                        data["rpm"]     = rpm
                    except queue.Empty:
                        #print("can_queue is empty")
                        pass
                    
                    # get last message from car_info_queue.
                    # If not empty get car info and save in data dict.
                    # If queue is empty, print message and use default dict
                    try:
                        car_info            = copy_car_info_queue.get_nowait() 
                        ip_address          = car_info[0]
                        battery_voltage     = car_info[1]
                        power_consumption   = car_info[2]
                        battery_current     = car_info[3]
                        battery_level       = car_info[4]
                        battery_hour        = car_info[5]
                        curtime             = car_info[6]
                        data["ip_address"]          = ip_address
                        data["battery_voltage"]     = battery_voltage
                        data["power_consumption"]   = power_consumption
                        data["battery_current"]     = battery_current
                        data["battery_level"]       = battery_level
                        data["battery_hour"]        = battery_hour
                        data["curtime"]             = curtime
                    except queue.Empty:
                        #print("car_info_queue is empty")
                        pass

                    # get last message from car_control_queue.
                    # If not empty get car control info and save in data dict.
                    # If queue is empty, print message and use default dict
                    try:
                        car_control     = copy_car_control_queue.get_nowait()
                        throttle        = car_control[0]
                        steering        = car_control[1]
                        indicator       = car_control[2]
                        data["throttle"]    = throttle
                        data["steering"]    = steering
                        data["indicator"]   = indicator
                    except queue.Empty:
                        #print("car_control_queue is empty")
                        pass

                    # convert all values in data to string
                    data = {key: str(value) for key, value in data.items()}

                    # create a json message from data dict
                    message = json.dumps(data)

                    # send message to client
                    try:
                        #send message to client as utf-8 encoded string
                        conn.sendall(message.encode('utf-8'))

                        # print message with timestamp to console
                        #print(f"{int(time.time())} - {message}")

                    except (BrokenPipeError, ConnectionResetError):
                        print("Client disconnected, waiting for another connection")
                        break

                    # sending interval, 60 Hz
                    time.sleep(1/10)

            conn.close()

        except BlockingIOError:
            # No connection yet, wait for a bit
            print("Waiting for connection")
            pass    

        except KeyboardInterrupt:
            # Exit with cmd+c
            print("Send_data process has been stopped.")
            # shut down the socket server
            soc.close()
            break

        except Exception as e:
            print("Send_data process has been stopped.")
            print("An error occurred:", e)  
            break

    soc.close()

