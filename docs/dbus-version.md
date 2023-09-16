# DES02-PiRacer-instrument
 Branch Version DBUS

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

## Demonstration
<img src="./docs/imgs/demonstration.gif">
