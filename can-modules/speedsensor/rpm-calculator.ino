#include <SPI.h>
#include <mcp_can.h>

#define SPEED_SENSOR_PIN 2
MCP_CAN CAN(10);

/** values to calculate RPM */
#define PPR 20
#define PI 3.1415926535897932384626433832795
#define WheelDiameter 65.0 // [mm]
#define SpeedSensorDiameter 20.0 // [mm]
#define RPM_SENSOR_MAX 1800 // Max. RPM of sensor

double sample_rate = 0.0;
double elapsedTimeAvg = 0.0;
double elapsedTimeSum = 100000.0;
double elapsedTime = 0;
double prevTime = 0;

unsigned long millis_before = 0;
unsigned long frqRaw = 0;
unsigned short RPM_s = 0;
unsigned short RPM_w = 0;
unsigned short speed = 0;
int tmpReadCnt = 0;
int readingCnt = 1;
int purseCnt = 1;

uint8_t data[8];
int can_id = 0x125;
int can_dlc = 8;
double C = WheelDiameter * PI / 1000;
int status = 0;

void setup() {
  Serial.begin(115200);
  pinMode(SPEED_SENSOR_PIN, INPUT);

  CAN.begin(MCP_ANY, CAN_125KBPS, MCP_8MHZ);
  CAN.setMode(MCP_NORMAL);

  // Nyquist-Shannon Sampling Theorem
  sample_rate = (1 / ( 2 * (RPM_SENSOR_MAX / 60))) * 1000; // calculate sample rate (Nyquist) in ms

  attachInterrupt(digitalPinToInterrupt(SPEED_SENSOR_PIN), pulseCounter, RISING);
}

void loop() {
  if (millis() - millis_before >= sample_rate) {
    detachInterrupt(digitalPinToInterrupt(SPEED_SENSOR_PIN));

    if (elapsedTimeAvg == 0) frqRaw = 0;
    else  frqRaw = 1000000 * 1000 / elapsedTimeAvg;
    RPM_s = (frqRaw * 60 / PPR) / 1000;
    frqRaw = 0;
    elapsedTimeAvg = 0;

    millis_before = millis();

    attachInterrupt(digitalPinToInterrupt(SPEED_SENSOR_PIN), pulseCounter, RISING);
  }

  RPM_w = RPM_s * (SpeedSensorDiameter / WheelDiameter);
  speed = RPM_w * C;

  data[0] = (RPM_w >> 0) & 0xFF;
  data[1] = (RPM_w >> 8) & 0xFF;
  Serial.print("RPM: "); Serial.print(RPM_w); Serial.print(" Speed [m/min]: "); Serial.println(speed);

  status = CAN.sendMsgBuf(can_id, 0, can_dlc, data);
  if (status == CAN_OK) {
    Serial.println("Success");
  } else
    Serial.println("Error");
  delay(50);
}

void pulseCounter() {
  elapsedTime = micros() - prevTime;
  prevTime = micros();

  if (purseCnt >= readingCnt) {
    elapsedTimeAvg = elapsedTimeSum / readingCnt;
    purseCnt = 1;
    elapsedTimeSum = elapsedTime;

    tmpReadCnt = map(elapsedTime, 40000, 5000, 1, 10);
    readingCnt = constrain(tmpReadCnt, 1, 10);
  } else {
    purseCnt++;
    elapsedTimeSum += elapsedTime;
  }
}
