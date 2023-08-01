# Speed Calculation
## Step1. RPM Calculation
To get vector of RPM values, you need below variables:  
$N_k$ *[rpm]* - rpm value  
$PPR$ *[pulses/rev]* - pulses per revolution  
$pulse$ *[pulses]* - number of pulses in one second

#### Basic Formula
Basically, you can calculate rpm value by dividing number of pulses in one second by pulses per revolution and multiply by 60 to get rpm value.

$$
N_k = \frac{pulse}{PPR} \cdot 60
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
