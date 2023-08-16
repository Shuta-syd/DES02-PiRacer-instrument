# :art: Design-Renewal
**Table of contents**
- [:art: Design-Renewal](#art-design-renewal)
  - [Before](#before)
  - [After](#after)
    - [What data is transmitted?](#what-data-is-transmitted)
    - [First, let's make the design!](#first-lets-make-the-design)

<hr>

## Before

## After
### What data is transmitted?
- **About direction 🔽**
  - steering (float)
  - throttle (float)
  - ~indicator~ (int)
- **About battery 🔋**
  - battery_voltage (float, V)
  - battery_consumption (float, W)
  - battery_current (float, mA)
  - battery_level (float, %)
  - battery_hour (float, hour)
- **About speed 🚤**
  - speed (unsigned int, m/min)
  - rpm (unsigned int)
- **etc**
  - ip_address (string)
  - time (string, hh:mm)

### First, let's make the design!

[link to figma](https://www.figma.com/file/AbLx0dzamewmdk4J5WxrAq/DES02-PiRacer-Instrument-Dashboard?type=design&node-id=0%3A1&mode=design&t=hcxtPzIukX6i8xZH-1)


<img src="./imgs/dashboard.png" alt="DASHBOARD_IMG">

- Components
  - Top Navbar
    - MacOS-like decorations (no functions yet)
    - Time
  - Left part
    - RPM circular
  - Center part
    - Speed circular
  - Right part
    - Power consumption circular
    - Battery Information box
