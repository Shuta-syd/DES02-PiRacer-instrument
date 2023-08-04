import can
import time

can_interface = 'can0'

def receive_can_messages_thread(queue):
    try: 
        # create a can bus instance
        bus = can.interface.Bus(channel=can_interface, bustype='socketcan')
        while True:
            # Receive message from CAN bus
            # message = bus.recv() 
            # Put message into queue
            # queue.put(message.data[0])
            queue.put(10)
            time.sleep(1)
    except KeyboardInterrupt:
        bus.shutdown()
