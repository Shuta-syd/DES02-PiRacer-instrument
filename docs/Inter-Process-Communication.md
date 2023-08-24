# IPC (Inter Process Communication)

## Introduction

Inter-process communication (IPC) is a set of programming interfaces that allow a programmer to coordinate activities among different program processes that can run concurrently in an operating system. This allows data to be shared between processes. 

The following table shows different approaches to IPC tailored to specific needs. Most modern operating systems support many of these methods.  

| Method            | Short Description                                                                      |
|---------------------------|-------------------------------------------------------------------------------|
| 📁 File| A record stored on disk, or a record synthesized on demand by a file server, which can be accessed by multiple processes.|
| 📶 Signal; also Asynchronous System Trap | A system message sent from one process to another, not usually used to transfer data but instead used to remotely command the partnered process. |
| 🔌 Socket| Data sent over a network interface, either to a different process on the same computer or to another computer on the network. Stream-oriented (TCP; data written through a socket requires formatting to preserve message boundaries) or more rarely message-oriented (UDP, SCTP). |
| ⩤ Unix domain socket| Similar to an internet socket, but all communication occurs within the kernel. Domain sockets use the file system as their address space. Processes reference a domain socket as an inode, and multiple processes can communicate with one socket |
| 📩 Message queue| A data stream similar to a socket, but which usually preserves message boundaries. Typically implemented by the operating system, they allow multiple processes to read and write to the message queue without being directly connected to each other. |
| 🛤 pipes | Anonymous: A unidirectional data channel using standard input and output. Data written to the write-end of the pipe is buffered by the operating system until it is read from the read-end of the pipe. Two-way communication between processes can be achieved by using two pipes in opposite "directions". <br> Named: A pipe that is treated like a file. Instead of using standard input and output as with an anonymous pipe, processes write to and read from a named pipe, as if it were a regular file. |
| 📋 Shared memory             | Multiple processes are given access to the same block of memory, which creates a shared buffer for the processes to communicate with each other. |
| ✉️ Message passing           | Allows multiple programs to communicate using message queues and/or non-OS managed channels. Commonly used in concurrency models. |
| 🗺 Memory-mapped file        | A file mapped to RAM and can be modified by changing memory addresses directly instead of outputting to a stream. This shares the same benefits as a standard file. |

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
 Applications that use D-Bus typically connect to a bus daemon, which forwards messages between the applications. 
 #### Session Bus
Each user login session should have a session bus, which is local to that session. It’s used to communicate between desktop applications. 

 #### System Bus
 The system bus is global and usually started during boot; it’s used to communicate with system services like systemd, udev and NetworkManager.

## What is different between D-Bus vs TCP/IP Socket
**1. Thy way to call server function**  
 The way to call server function in D-bus is like similar to call functions that you need only data in any programming languages while in TCP/IP we can select a particular data from server. You have to follow the server rules like where a serer put which data. That's why D-bus is theoretically quicker.

**D-BUS**
```
   QDBusMessage response = _iface->call("getSpeed");

    if(response.type() == QDBusMessage::ErrorMessage) {
        qDebug() << "Error: " << qPrintable(response.errorMessage());
        exit(1);
    }
    qreal value = response.arguments().at(0).toInt();
    return value;
```
**TCP/IP Socket**
```
  QTextStream _T(socket);
  QString _msg = _T.readAll();
  QStringList _list = _msg.split(",");
```
as the ways to call functions are different, literally D-bus can send bigger data than TCP/IP socket.


## Reference
[Get on the D-BUS](https://www.linuxjournal.com/article/7744)  
[D-BUS Tutorial](https://dbus.freedesktop.org/doc/dbus-tutorial.html#meta)  
[QDBUS Example](https://github.com/tkhshmsy/qtdbus-demo/tree/main)  
[Overview IPC](https://en.m.wikipedia.org/wiki/Inter-process_communication)
