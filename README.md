# DES02-PiRacer-instrument

## Table of contents
- [DES02-PiRacer-instrument](#des02-piracer-instrument)
  - [Table of contents](#table-of-contents)
  - [:microphone: Introduction](#microphone-introduction)
  - [:runner: Demonstration](#runner-demonstration)
  - [:classical\_building: Software Architecture](#classical_building-software-architecture)
  - [Project Structure](#project-structure)

## :microphone: Introduction
This project is part of [SEA-ME Project](https://github.com/SEA-ME).
> The PiRacer instrument cluster Qt application project is aimed at creating a real-time speedometer for a PiRacer car. The application will run on a Raspberry Pi and receive speed data from a speed sensor via the in-vehicle communication using Controller Area Network (CAN) protocol. This project will provide an opportunity for students to gain practical experience in software engineering, specifically in the areas of embedded systems, software architecture, and communication protocols. The project will also allow students to gain knowledge of the GUI frameworks (eg. Qt), that are widely used in the automotive industry for developing many embedded applications. The successful completion of this project will demonstrate the students' ability to design and implement a real-world software solution, and their ability to effectively communicate their results.

You can see the full subject in this link. [SEA-ME/DES-Instrument-Cluster](https://github.com/SEA-ME/DES-Instrument-Cluster)

## :runner: Demonstration
<img src="./docs/imgs/demonstration.gif" width="80%" margin="120%">

## :classical_building: Software Architecture
Application using `TCP Socket` ➝ [**`tcp-version` branch** *(link)*](https://github.com/tree/tcp-version)
Application using `D-BUS` ➝ [**`dbus-version` branch** *(link)*](https://github.com/tree/dbus-version)

| TCP Version | DBUS Version |
|:-------:|:-------:|
|<img src="./docs/imgs/architecture-socket.png" width="100%">|<img src="./docs/imgs/architecture-socket.png" width="100%">|

## Project Structure
``` bash
.
├── app
│   ├── d-bus # D-BUS server (python)
│   ├── dashboard # application dir for dashboard
│   │   ├── asset
│   │   │   └── qml
│   └── piracer_py # dir to control piracer (gamepad, display etc.)
├── can-modules # send data to can bus from any sensor
│   └── speedsensor
├── docs # docs explains this project
│   └── imgs
└── examples # example to understand project knowledge
    ├── can
    └── rpm-calc
```
