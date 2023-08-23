import pydbus

bus = pydbus.SessionBus()
bus_obj = bus.get("com.test.canDataReceiver")

try:
    while True:
        ret = bus_obj.getRpm()
        print(ret)
except KeyboardInterrupt:
    print("End")
