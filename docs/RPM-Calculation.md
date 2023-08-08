# Speed Calculation
## Step1. RPM Calculation
To get vector of RPM values, you need below variables:  

$RPM_s$ *[rpm]* - rpm value of Speed Sensor Wheel  
$PPR$ - pulses per revolution  
$pulse$ - number of pulses in one second

#### Basic Formula
Basically, you can calculate rpm value by dividing number of pulses in one second by pulses per revolution and multiply by 60 to get rpm value.

$$
RPM_s = \frac{pulse}{PPR} \cdot 60
$$

#### Pulse Counter
If you want to get more accurate rpm value, you can use pulse counter.
In this case, we are using micro second as time unit So That's why we need to convert it to seconds by dividing it by 1000000.

$$
frqRaw (pulse) = \frac{1000000}{ElapsedTimeAvg}
$$

$$
ElapsedTimeAvg = \frac{ElapsedTime}{ReadingCount}
$$

## Step2 Speed Calculation km/h
To get speed km/h, you need below variables:  

$Speed$ *[m/min]* - speed value  
$RPM_w$ - rpm value of Wheel
$rpm$ - rpm value  
$C$ *[m]* - Circumference length of Wheel  
$d_1$ *[mm]* - Diameter of Wheel  
$d_2$ *[mm]* - Diameter of Speed Sensor Wheel  

#### Basic Formula
$$
Speed(m/min) = RPM_w \cdot C
$$

$$
RPM_w = {RPM_s} \cdot {GearRatio}
$$

$$
GearRatio = \frac{d_2}{d_1} (d1 > d2)
$$ 

$$
C = \frac{d_1 \cdot \pi}{1000}
$$
