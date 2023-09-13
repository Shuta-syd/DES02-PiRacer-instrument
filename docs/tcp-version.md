# Piracer_py Application with TCP/IP Socket

!!!! DOCUMENTATION IN PROGRESS !!!!

We decided to build two versions of the Piracer Application. <br>
V1 [branch for tcp-version](/Shuta-syd/DES02-PiRacer-instrument/tree/tcp-version) <br>  and V2 [branch for dbus-version](/Shuta-syd/DES02-PiRacer-instrument/tree/dbus-version) <br>
The following documentation narrows down the details on [V1 (tcp-version)](/Shuta-syd/DES02-PiRacer-instrument/tree/tcp-version). 

## Introduction
### Multiprocessing
Multiprocessing in Python is a module that enables concurrent execution of multiple processes, allowing programs to utilize multiple CPU cores for improved performance. It provides a way to create and manage separate processes, each with its own memory space and resources, allowing them to run independently. This is particularly useful for CPU-bound tasks, such as data processing and intensive computations, as it can significantly reduce execution time. Python's multiprocessing module offers a high-level interface for creating and managing processes, with features like the Pool class for parallelizing function calls and tools for inter-process communication like pipes and queues. It is a powerful tool for optimizing multi-core systems and achieving faster program execution in Python.

### Queues
Queues in Python's `multiprocessing` module enable secure communication between concurrent processes by preventing data corruption and race conditions. <br>
Processes can use the `put()` and `get()` methods to add and retrieve items from the queue, maintaining synchronization. <br>
The FIFO queues are used to provide values from Process 1-3 on Process 4. <br>

### Monitoring
See [Execption.md](../docs/exception.md) 

## Software Architecture
### Processes
This python application runs four Processes which are responsible for the follwoing tasks: 

|Process			   |Task																	|
|:--------------------:|:----------------------------------------------------------------------:|
| ℹ️ <br>Car_Info		   | Display ip address & battery information on the on-board OLED display	|         
| 🚗 <br> Remote_Controll   | Throttle and steering controll via Gamepad-Remotecontrol    			|
| ➡️ <br> Recieve_Data | Recieve data from CAN-Bus                                   				|
| 📡 <br> Send_Data | Send send via TCPS socket. 				|

#### Process 1 - Display Car Info
ℹ️ [car_info.py](../app/piracer_py/process/car_info.py) <br>
The function utilizes the PiRacerStandard class to access the vehicle's battery data and the socket module to retrieve the local IP address.<br>
The earned information includes battery voltage, current, power consumption, local IP address, and current time. <br>
 <br>

#### Process 2 -  Remote Controll 
🚗[car_control.py](../app/piracer_py/process/car_control.py) <br>
This Python script allows remote control of a PiRacerStandard vehicle using the ShanWanGamepad module. <br>
The car_control function takes input from the gamepad's analog sticks for throttle and steering. <br>
The vehicle's throttle and steering angles are then set based on these inputs to drive the car. <br>
The script runs in an infinite loop until interrupted by the user, and upon interruption, the car's throttle and steering are set to 0 for safety. <br>

!!! Insert picture of Gamepad & Gif of driving Piracer here !!! <br>

#### Process 3 - Recieve Data 
➡️[recieve_data.py](../app/piracer_py/process/recieve_data.py) <br>
This Python script utilizes the can library to communicate with CAN (Controller Area Network) devices and extract data from sensors. It employs the socketcan bus interface for communication and handles the reception of data from a specific CAN ID. The received data is processed to calculate the speed of a wheel based on RPM and wheel diameter. The calculated speed and RPM values are then stored in a queue, ensuring efficient data storage even when the queue is full. The script provides a robust mechanism for extracting and processing sensor data, while the KeyboardInterrupt is supported for graceful termination.

#### Process 4 - Send Data 
📡[send_data.py](../app/piracer_py/process/send_data.py) <br>
While using inter-process-communication (IPC), we have to decide which method we want to use.
An overview of the different methods can be found in [Inter-Process-Communication.md](../docs/Inter-Process-Communication.md). <br>

In terms of IPC, sockets provide good performance and flexibility for inter-process communication (IPC), especially when using binary data serialization. <br>
🤔 But what socket type should we use? TCP/IP or Unix domain sockets? 
- Unix domain sockets are used for communication between processes on the same machine by using the local file system as their address space. <br>
They are relatively efficient because they avoid the overhead of the network protocol.
- TCP/IP sockets are generally used for communication between processes on different machines, but can also been used for the communication between processes on the same machine. 
🤯 We made the decision to try both TCP/IP socket (V1) and DBus (V2) like mentioned ealier. </a>
<br>

This Python script establishes a socket server that communicates with a client, sending real-time data from a vehicle. <br>
The received information from the can bus like speed and RPM are merged with car control and other car-related information data from queues. <br>
The script uses queues to collect real-time data from different sources, facilitating safe inter-process communication. <br>

# References
[[1]](https://docs.python.org/3/library/multiprocessing.html), 
[[2]](https://python-can.readthedocs.io/en/stable/), 
[[3]](https://realpython.com/python-sockets/), 
[[4]](https://docs.python.org/3/library/socket.html)
