import queue
import can
import time

can_interface = 'can0'

def receive_can_messages_thread(queue):
    try: 
        bus = can.interface.Bus(channel=can_interface, bustype='socketcan') #native socket scan
        while True:
            message = bus.recv()
            if message is None:
            	print("No CAN message")
	    # Get first element of bytearray (this element holds the speed sensor data)
            value = message.data[0]	
            print(f"{value}") 
            # Store value in queue
            queue.put(value)
            time.sleep(1)
    except KeyboardInterrupt:
        bus.shutdown()
