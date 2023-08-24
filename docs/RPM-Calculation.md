# Speed Calculation
## Step1. Calculate Sampling Rate according to Nyquist Theorem
The Nyquist Theorem states that the sampling frequency (also known as the sampling rate) must be at least twice the highest frequency component in the signal to ensure lossless reproduction of the signal after sampling.

$T_a$ - the sampling period (time between consecutive samples)  
$f_{max}$ - Maximum Frequency

$$
T_a \leq \frac{1}{2 \cdot f_{max}}
$$

> 100% throttle the piracer accelerate the speed sensor disk up to rpm_sensor = 1800

$$
  sampleRate = \frac{1}{2 \cdot \frac{RPM_{max}}{60}} * 1000
$$

> to get sampling rate in milliseconds, we need to multiply by 1000

## Step2. RPM Calculation
To get vector of RPM values, you need below variables:  

$RPM_s$ - rpm value of Speed Sensor Wheel  
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

## Step3. Speed Calculation km/h
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
