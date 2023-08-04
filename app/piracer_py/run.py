import  time
from  multiprocessing                 import Process 
from    piracer.vehicles              import PiRacerStandard
from    piracer.gamepads              import ShanWanGamepad
from    process.display_carinfo       import display_carinfo
from    process.car_control           import car_control
from    process.data_transmission     import data_transmission

if __name__ == '__main__':
    
    piracer         = PiRacerStandard()             
    shanwan_gamepad = ShanWanGamepad()

    try:      
        # Run display_carinfo() in a seperate process 
        display_carinfo_process = Process(target=display_carinfo, args=(piracer,))
        display_carinfo_process.start()

        # Run car_controll() in a seperate process 
        car_control_process = Process(target=car_control, args=(piracer, shanwan_gamepad))
        car_control_process.start()

        # Run data_transmission() in a seperate process
        data_transmission_process = Process(target=data_transmission)
        data_transmission_process.start()

        # Wait for processes to finish
        display_carinfo_process.join()
        car_control_process.join()
        data_transmission_process.join()

    except KeyboardInterrupt:
        # Exit with cmd+c
        print(" - Programm has been stopped. - ")
        pass
