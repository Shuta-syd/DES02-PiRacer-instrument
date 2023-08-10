
## Inter-Process Communication

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

Reference: [Wikipedia](https://en.m.wikipedia.org/wiki/Inter-process_communication)



# IPC (Inter Process Communication)
## What is D-BUS?
D-BUS is an interprocess communication(IPC) system, providing a simple yet powerful mechanism allowing applications to talk to one another, communication information and request services.

## D-BUS vs TCP/IP socket vs Unix socket
### D-BUS

## Reference
[Get on the D-BUS](https://www.linuxjournal.com/article/7744)

