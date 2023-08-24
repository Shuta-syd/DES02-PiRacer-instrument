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

```
- About direction 🔽
  - steering
    - float
      - -1 ~ 1
  - throttle
    - float
      - -100 ~ 100
  - indicator
    - int
      - 0: nothign
      - 1: left
      - 2: right
      - 3: warning light

- About battery 🔋
  - battery_voltage
    - float
    - V
  - battery_consumption
    - float
    - W
  - battery_current
    - float
    - mA
  - battery_level
    - float
    - %
  - battery_hour
    - float
    - hour

- About speed 🚤
  - speed
    - unsigned short
    - m/min
  - rpm
    - unsigned short

- etc
  - ip_address
    - string
  - time
    - string
    - hh:mm
```

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
=======
- About direction 🔽
  - Steering
  - Throttle
  - Indicator
- About battery 🔋
  - battery voltage (V)
  - power consumption (W)
  - current (mA)
- About speed
  - speed (m/min)
  - rpm

### First, let's make the design!

<iframe style="border: 1px solid rgba(0, 0, 0, 0.1);" width="800" height="450" src="https://www.figma.com/embed?embed_host=share&url=https%3A%2F%2Fwww.figma.com%2Ffile%2FAbLx0dzamewmdk4J5WxrAq%2FDES02-PiRacer-Instrument-Dashboard%3Ftype%3Ddesign%26node-id%3D0%253A1%26mode%3Ddesign%26t%3DhcxtPzIukX6i8xZH-1" allowfullscreen></iframe>
