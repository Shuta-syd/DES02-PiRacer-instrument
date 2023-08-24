# Piracer_py Application

That's how we build our PiRacer_py Application. 

# Introduction

This python application runs three Processes which are responsible for the follwoing tasks: 

|Process			   |Task																	|
|:--------------------:|:----------------------------------------------------------------------:|
| ℹ️ <br>Car_Info		   | Display ip address & battery information on the on-board OLED display	|         
| 🛞 <br> Remote_Controll   | Throttle and steering controll via Gamepad-Remotecontrol    			|
| 📡 <br> Data_Transmission | Recieve data from CAN-Bus & send to RPi's socket. 				|

💡Note: The script is designed to be run on a Raspberry Pi 4 with a PiRacerStandard vehicle and an SSD1306 I2C on-board display. 

# Display Car Info
This Python script provides a function called display_carinfo that shows real-time car-related data on an SSD1306 I2C display. The function utilizes the PiRacerStandard class to access the vehicle's battery data and the socket module to retrieve the local IP address.The displayed information includes battery voltage, current, power consumption, local IP address, and current time. <br>

!!! insert picture of OLED here !!! <br>

# Gamepad Remote Controll 
This Python script allows remote control of a PiRacerStandard vehicle using the ShanWanGamepad module. The car_control function takes input from the gamepad's analog sticks for throttle and steering. The vehicle's throttle and steering angles are then set based on these inputs to drive the car. The script runs in an infinite loop until interrupted by the user, and upon interruption, the car's throttle and steering are set to 0 for safety. <br>

!!! Insert picture of Gamepad & Gif of driving Piracer here !!! <br>

# Recieve Data from CAN Bus & Send to Dashboard

While using inter-process-communication (IPC), we have to decide which method we want to use.
An overview of the different methods can be found [here](../docs/Inter-Process-Communication.md).

In terms of IPC, sockets provide good performance and flexibility for inter-process communication (IPC), especially when using binary data serialization. <br>
🤔 But what socket type should we use? TCP/IP or Unix domain sockets? 
- Unix domain sockets are used for communication between processes on the same machine by using the local file system as their address space. They are relatively efficient because they avoid the overhead of the network protocol.
- TCP/IP sockets are generally used for communication between processes on different machines, but can also been used for the communication between processes on the same machine. 

🤯 We made the decision to choose the TCP/IP socket because we want to be able to run the dashboard on a different machine than the PiRacer_py application. </a>
<br>


📡 [data_transmission.py](../app/piracer_py/data_transmission.py) transmits data from a CAN bus to a socket server. The function utilizes the python-can module to access the CAN bus and the socket module to create a socket instance and send data to the socket server.
This script is designed to handle continuous data transmission from a CAN bus to a socket server, providing speed information based on the wheel's RPM and circumference.
Depending on the sender ID on the CAN BUS(`message.arbitration_id`), the function interprets the data payload as a representing the RPM of the wheel.
The script then calculates the speed in meters per minute (m/min) based on the wheel's RPM and circumference. The speed is then sent to the socket server.
If no data is received from the CAN bus, the function sends a 0 to the socket server.

# References
[[1]](https://docs.python.org/3/library/multiprocessing.html), 
[[2]](https://python-can.readthedocs.io/en/stable/), 
[[3]](https://realpython.com/python-sockets/), 
[[4]](https://docs.python.org/3/library/socket.html)

