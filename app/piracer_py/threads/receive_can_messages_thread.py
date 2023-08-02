import can
import time

can_interface = 'can0'

def receive_can_messages_thread():
    bus = can.interface.Bus(channel=can_interface, bustype='socketcan')
    try: 
        while True:
            message = bus.recv()
            print(message)
            time.sleep(1);
            #print(f"recieve ID={message.arbitration_id}, data={message.data}")
    except KeyboardInterrupt:
        pass