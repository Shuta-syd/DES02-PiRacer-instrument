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
