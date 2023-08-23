# CAN module Speed Sensor 

!! Not yet done !! 

## Calculation
### Get the maximum frequency component in the signal
Using a test code snipped from ...
At 100% throttle the piracer accelerate the speed sensor disk up to rpm_sensor = 1800 1/min. Therfore, the highest highest frequency component in our signal is 1800 1/min.

### Sampling Rate according to Nyquist Theorem
The Nyquist Theorem states that the sampling frequency (also known as the sampling rate) must be at least twice the highest frequency component in the signal to ensure lossless reproduction of the signal after sampling. [1]

The formula for calculating the minimum sampling rate:


$$
T_a \leq \frac{1}{2 \cdot f_{max}}
$$

Where:

$T_a$ - is the sampling period (time between consecutive samples)

In this case, the maximum frequency component our signal is 1800 1/min.

$f_{max}$ -  is the maximum frequency in the signal

Substituting the values:
$$
T_a = \frac{1}{2 \cdot 1800 \text{ 1/min}} 
= \frac{1}{2 \cdot 30 \text{ 1/s}} 
= \frac{1}{60} \text{s}

≈ 16.6... \text{ms}
$$

In the code it is implemented as follows:
```c
sample_rate = (1/(2*(RPM_SENSOR_MAX/60)))*1000;
```
### Wheel Rotation per Minute

The RPM is calculated by the following formula:
```
rpm = 60 / (pulse_duration * pulses_per_revolution)
``` 
## Send via CAN 
### Message format
Using usigned short (16 bits, value range: 0 - 65535) is enough to store the value. The CAN message can only send 8 bytes at a time. Therefore, the 2x8 Bit long rpm_wheel value must be divided into two bytes. 
To get the first 8 Bits of the values, we shift the value 8 Bits to the right and mask with 0xFF (1111 1111 bin) to keep only the last 8 bits. To get the last 8 Bits of the values, we mask with 0xFF (1111 1111 bin) to keep only the last 8 bits. 
The can frame message looks like this:

| **Byte** | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Content** |rpm_wheel|rpm_wheel|0|0|0|0|0|0|

## Dual SPI Mode

The 2-CH CAN FD HAT use interface can1 by default in Dual SPI Mode. The following steps are necessary to use the interface can1:

" The above configuration is based on the Raspbian OS system.
'A' mode (default mode), use SPI0-0 and SPI1-0 to control two CAN channels, hardware does not need any modification, namely:
CAN_0 uses SPI0-0, interrupt pin is 25, CAN_1 uses SPI1-0, interrupt pin is 24

Insert the module to Raspberry Pi, and then modify config.txt file:

``` bash
sudo nano /boot/config.txt
```
Add the following commands at the last line:
``` bash
dtparam=spi=on
dtoverlay=spi1-3cs
dtoverlay=mcp251xfd,spi0-0,interrupt=25
dtoverlay=mcp251xfd,spi1-0,interrupt=24
``` 
After the addition is complete, restart and enter the 'Configure CAN' chapter. " (see: [2])

## Setup CAN interface 
To use the CAN interface on the Raspberry Pi, the following steps are necessary. 
This script sets up the CAN bus interface.
``` shell
sudo ip link set can0 up type can bitrate 125000 dbitrate 8000000 restart-ms 1000 berr-reporting on fd on
sudo ip link set can1 up type can bitrate 125000 dbitrate 8000000 restart-ms 1000 berr-reporting on fd on
```

# References
[[1]](https://www.mathworks.com/help/signal/ug/nyquist-sampling-theorem.html)
[[2]](https://www.waveshare.com/wiki/2-CH_CAN_FD_HAT#Single_SPI_Mode)
