import can
import queue

# CAN ID for sensors
speedsensor_can_id  = 0x125     
# CAN bus interface (socketcan)
bus_interface       = 'can0'    

def recieve_data(q):
    try:
        # Set up CAN bus
        bus = can.interface.Bus(channel=bus_interface, bustype='socketcan')

        # Recieve data from can bus
        while True:
            # Receive message from CAN bus (if bus.recv() is blocking, do not block for more than 1 second)
            message = bus.recv(timeout=10.0)
            # if message is not None:
            if message is not None:
                if message.arbitration_id == speedsensor_can_id:
                    #print informations about message
                    #print(f"Timestamp: {int(time.time())} ID: {message.arbitration_id} DLC: {message.dlc} DATA: {message.data}")
                    #print recieved byte array (message.data)
                    #print("byte array message.data: ",'|'.join(str(value) for value in message.data))
                    #extract rpm_wheel and speed from byte array (message.data)
                    rpm_wheel = message.data[2] << 8 | message.data[3] 
                    speed     = message.data[0] << 8 | message.data[1] 
                    #print rpm_wheel and speed as integer
                    print("RPM =   ",rpm_wheel," 1/min ", "Speed = ",speed," m/min ")
                    #load data in queue. If queue is full, than empty oldest data and load new data
                    try:
                        q.put_nowait((speed, rpm_wheel))
                    except queue.Full:
                        q.get()
                        q.put((speed, rpm_wheel))
    except KeyboardInterrupt:
        # Exit with cmd+c
        bus.shutdown()
        print(" - Recieve_data process has been stopped. - ")