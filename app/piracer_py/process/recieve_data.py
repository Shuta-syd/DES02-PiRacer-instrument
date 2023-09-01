import can
import queue
import math

# CAN ID for sensors
speedsensor_can_id  = 0x125     
# CAN bus interface (socketcan)
bus_interface       = 'can1'    

def recieve_data(q):

    #rpm queue for rpm_wheel moving average calulation
    rpm_queue = queue.Queue(maxsize=10)
    speed_queue = queue.Queue(maxsize=10)

    try:
        # Set up CAN bus
        bus = can.interface.Bus(channel=bus_interface, bustype ='socketcan')

        # Recieve data from can bus
        while True:
            # Receive message from CAN bus (if bus.recv() is blocking, do not block for more than 1 second)
            message = bus.recv(timeout=1.0)

            # if message is not None:
            if message is not None:

                if message.arbitration_id == speedsensor_can_id:
                    #print informations about message
                    #print(f"Timestamp: {int(time.time())} ID: {message.arbitration_id} DLC: {message.dlc} DATA: {message.data}")
                    
                    #print recieved byte array (message.data)
                    #print("byte array message.data: ",'|'.join(str(value) for value in message.data))

                    #extract rpm_wheel and speed from byte array (message.data)
                    rpm_wheel     = message.data[0] << 8 | message.data[1] 
                    
                    # calulate speed 
                    wheel_diameter = 65.0
                    circumference = (wheel_diameter*math.pi) / 1000
                    speed = round(abs(rpm_wheel * circumference),3)

                    # moving average rpm
                    try: 
                        rpm_queue.put_nowait(rpm_wheel)
                    except queue.Full:
                        rpm_queue.get()
                        rpm_queue.put(rpm_wheel)
                    rpm_wheel_list = list(rpm_queue.queue)
                    rpm_wheel = round(sum(rpm_wheel_list)/len(rpm_wheel_list), 3)

                    # moving average speed
                    try:
                        speed_queue.put_nowait(speed)
                    except queue.Full:
                        speed_queue.get()
                        speed_queue.put(speed)  
                    speed_list = list(speed_queue.queue)
                    speed = round(sum(speed_list)/len(speed_list), 3)

                    #print rpm_wheel and speed as integer
                    #print("RPM =   ",rpm_wheel," 1/min ", "Speed = ",speed," m/min ")

                    #load data in queue. If queue is full, than empty oldest data and load new data
                    try:
                        q.put_nowait((speed, rpm_wheel))
                    except queue.Full:
                        q.get()
                        q.put((speed, rpm_wheel))
            else:
                print("No message recieved from CAN bus.")

    except KeyboardInterrupt:
        # Exit with cmd+c
        bus.shutdown()
        print("Recieve_data process has been stopped.")