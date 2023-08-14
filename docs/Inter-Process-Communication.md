# IPC (Inter Process Communication)
## What is D-BUS?
D-BUS is an interprocess communication(IPC) system, providing a simple yet powerful mechanism allowing applications to talk to one another, communication information and request services. 

 D-BUS only supports one-to-one connections, just like a raw network socket. However, rather than sending byte streams over the connection, you send messages. Messages have a header identifying the kind of message, and a body containing a data payload which are easier to manage and interpret in a meaningful way. This approach allows for a more organized and semantically meaningful way of exchanging data between processes.

D-BUS signals are used to notify other components or applications about events or changes that have occurred within a process or service. Signals are a way for a process to broadcast information to other processes that are interested in receiving that information. 

![D-BUS](./imgs/D-BUS.png)
### Byte Streams
 In traditional network socket communication or raw communication between processes, data is often transmitted as a stream of bytes. This is akin to sending a continuous flow of data without any inherent structure. The recipient needs to interpret the bytes correctly based on some predefined rules.

 ### Messages (D-BUS)
 operates differently. Instead of sending raw byte streams, you send structured messages. A message in this context refers to a packet of data that has a predefined structure and metadata. This structure typically includes things like the sender's and receiver's identifiers, the message type, and the actual data payload. The library handles the details of this structure, ensuring that the messages are well-formed and can be easily understood by both the sender and receiver

 ### Why is D-bus stable and secure?
 D-Bus operates on a message-based architecture, which means that communication between processes is achieved through well-defined messages. This isolation of messages helps in preventing unintended interference between processes.

 ### SessionBus vs SystemBus
 #### SessionBus
 


## Reference
[Get on the D-BUS](https://www.linuxjournal.com/article/7744)  
[D-BUS Tutorial](https://dbus.freedesktop.org/doc/dbus-tutorial.html#meta)
[QDBUS Example](https://github.com/tkhshmsy/qtdbus-demo/tree/main)
