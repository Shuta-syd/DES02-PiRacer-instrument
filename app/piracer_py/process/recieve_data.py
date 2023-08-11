import can
import math
import queue

# CAN interfaces
can_interface_0       = 'can0'        
can_interface_1       = 'can1'  
# CAN ID for sensors
speedsensor_can_id  = 0x125      

def recieve_data(q):
    try:
        # Configure can bus connection
        bus_0 = can.interface.Bus(channel=can_interface_0, bustype='socketcan')
        bus_1 = can.interface.Bus(channel=can_interface_1, bustype='socketcan')

        print("Bus Channel: ", bus_0.channel_info, "Bus State: ", bus_0.state)
        print("Bus Channel: ", bus_1.channel_info, "Bus State: ", bus_1.state)

        bus = bus_0

        while True:
            # Receive message from CAN bus (if bus.recv() is blocking, do not block for more than 1 second)
            message = bus.recv(timeout=1.0)
            # if message is not None:
            if message is not None:
                if message.arbitration_id == speedsensor_can_id:
                    #extract data from message
                    rpm_wheel = message.data[3] 
                    speed = message.data[1]
                    #print message & data 
                    #print(f"Timestamp: {int(time.time())} ID: {message.arbitration_id} DLC: {message.dlc} DATA: {message.data}")
                    print("message.data: ",'|'.join(str(value) for value in message.data))
                    #print("RPM =   ",rpm_wheel," 1/min ")
                    #print("Speed = ",speed," m/min ")
                    #load data in queue. If queue is full, than empty oldest data and load new data
                    try:
                        q.put_nowait((speed, rpm_wheel))
                    except queue.Full:
                        q.get()
                        q.put((speed, rpm_wheel))
    except KeyboardInterrupt:
        # Exit with cmd+c
        bus.shutdown()
        bus_1.shutdown()
        print(" - Recieve_data process has been stopped. - ")