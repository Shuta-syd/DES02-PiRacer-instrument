#include <SPI.h>

//  MACROS FOR EXECUTION
#define BAUD_RATE       115200
#define SENSOR_PIN      2

void    setup(void)
{
    Serial.begin(BAUD_RATE);
    pinMode(SENSOR_PIN, INPUT);

    attachInterrupt(digitalPinToInterrupt(SENSOR_PIN), purseEvent, RISING);
    delay(1000);
}

//  MACROS FOR CALCULATION
#define PPR             20      // Purses Per Rotation
#define ZERO_TIMEOUT    100000  // Timeout period(microsecond) for RPM reset
#define NUM_READINGS    2       // Number of samples for moving average calculation
#define PULSE_DISTANCE  6.8e-3  // Distance per pulse in m/s

//  NUMBERS FOR CALCULATION
volatile unsigned long  prevTimeMeasured;
volatile unsigned long  purseInterval = ZERO_TIMEOUT + 1000;  // initial value must be bigger than timeout period
volatile unsigned long  intervalAvg = ZERO_TIMEOUT + 1000;
unsigned long           intervalSum;
unsigned int            readingsCnt = 1;
unsigned int            purseCounter = 1;
unsigned long           frqRaw;
unsigned long           RPM;

unsigned long           prevCycleTime = prevTimeMeasured;
unsigned long           currMicroSec = micros();
unsigned int            zeroDebounce;
unsigned int            amountReadings = 1;
unsigned long           readings[NUM_READINGS];
unsigned long           rIndex;
unsigned long           total;
unsigned long           average;
unsigned long           speed;

void    loop(void)
{
    //  time measure part
    prevCycleTime   = prevTimeMeasured;
    currMicroSec    = micros();

    //  time error check (overflow)
    if (currMicroSec < prevCycleTime)
        prevCycleTime = currMicroSec;

    //  pulse frequency calculation
    //  - 1s * 1000 / average purse interval
    //  - reason of dividing with 1000 : to reduce errors of calculating float things
    frqRaw = 10000000000 / intervalAvg;

    //  zerodebounce setting to prevent noises
    if ((purseInterval) > (ZERO_TIMEOUT - zeroDebounce) ||
        (currMicroSec - prevCycleTime) > ZERO_TIMEOUT - zeroDebounce)
    {
        frqRaw       = 0; // set frequency as 0
        zeroDebounce = 2000;
    }
    else
        zeroDebounce = 0;

    //  RPM calculating (m/s)
    RPM              = frqRaw / PPR * 60;
    RPM              = RPM / 10000;
    speed            = PULSE_DISTANCE * RPM;

    //  calculating average speed
    total            = total - readings[rIndex];
    readings[rIndex] = speed;
    total            = total + readings[rIndex];
    rIndex           = rIndex + 1;
    average          = total / NUM_READINGS;

    //  readomg index init
    if (rIndex >= NUM_READINGS)
        rIndex = 0;

    //  printing
    Serial.print("Interval: [");
    Serial.print(purseInterval);
    Serial.print(" μs]");

    Serial.print("\tSpeed: [");
    Serial.print(speed);
    Serial.print(" m/s]");

    Serial.print("\tAverage: [");
    Serial.print(average);
    Serial.println(" m/s]");
}

//  ISR(Interrupt Service Routine)
//      when purse from the sensor was detected
void    purseEvent(void)
{
    // time setting
    purseInterval     = micros() - prevTimeMeasured;
    prevTimeMeasured  = micros();

    if (purseCounter >= readingsCnt)
    {
        intervalAvg   = intervalSum / readingsCnt;
        purseCounter  = 1;
        intervalSum   = purseInterval;

        int tmpReadCnt= map(purseInterval, 40000, 5000, 1, 10);
        tmpReadCnt    = constrain(tmpReadCnt, 1, 10);
        readingsCnt   = tmpReadCnt;
    } else {
        purseCounter++;
        intervalSum   = intervalSum + purseInterval;
    }
}
