# DES02-PiRacer-instrument
## Branch Version
Application using D-BUS -> `dbus-version` branch  
Application using TCP/IP -> `tcp-version` branch

## Demonstration
<img src="./docs/imgs/demonstration.gif">

## Contents Index
[1. Software Architecture](#software-architecture)  
[2. Basic knowledge of Architecture](./docs/Basic-Knowledge-of-the-Architecture.md)  
[3. CAN Communication](./docs/CAN-Communication.md)  
[4. RPM Calculation](./docs/RPM-Calculation.md)  
[5. Battery Calculation](./docs/Battery_Level_Calculation.md)  
[6. Inter Process Communication](./docs/Inter-Process-Communication.md)  
[7. Qt & QML](./docs/Qt-QML.md)  
[8. Startup Routine](./docs/Startup-Routine.md)  
[9. Exception](./docs/Exception.md)  

## Software Architecture
<img src="./docs/imgs/software-architecture.png" width="75%" height="75%">

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
