#include <SPI.h>
#include <mcp_can.h>

#define SPEED_SENSOR_PIN 2
MCP_CAN CAN(10);

/** values to calculate RPM */
#define PPR 20
#define PI 3.1415926535897932384626433832795
#define ZERO_TIMEOUT    60000  // Timeout period(microsecond) for RPM reset
#define WheelDiameter 65.0 // [mm]
#define SpeedSensorDiameter 20.0 // [mm]

double elapsedTimeAvg = 0.0;
double elapsedTimeSum = 100000.0;
double elapsedTime = 0;
double prevTime = 0;
unsigned int zeroDebounce = 0;
unsigned long frqRaw = 0;
unsigned short RPM_s = 0;
unsigned short RPM_w = 0;
unsigned short speed = 0;
int readingCnt = 1;
int purseCnt = 1;


void setup() {
  Serial.begin(115200);
  pinMode(SPEED_SENSOR_PIN, INPUT);

  CAN.begin(MCP_ANY, CAN_125KBPS, MCP_8MHZ);
  CAN.setMode(MCP_NORMAL);

  attachInterrupt(digitalPinToInterrupt(SPEED_SENSOR_PIN), purseCounter, RISING);
}

void loop() {
  uint8_t data[8];
  int can_id = 0x125;
  int can_dlc = 8;
  double C = WheelDiameter * PI / 1000;

  double prev_cycle_time = micros();
  double current_time = micros();
  frqRaw = 1000000 * 1000 / elapsedTimeAvg;

  if (elapsedTime > (ZERO_TIMEOUT - zeroDebounce) || (current_time - prev_cycle_time) > (ZERO_TIMEOUT - zeroDebounce)) {
    frqRaw = 0;
     zeroDebounce = 2000;
  } else  zeroDebounce = 0;

  RPM_s = (frqRaw * 60 / PPR) / 1000;
  RPM_w = RPM_s * (SpeedSensorDiameter / WheelDiameter);
  speed = RPM_w * C;

  Serial.print("RPM: "); Serial.print(RPM_w); Serial.print(" Speed [m/min]: "); Serial.println(speed);

  data[0] = (RPM_w >> 0) & 0xFF;
  data[1] = (RPM_w >> 8) & 0xFF;

  int status = CAN.sendMsgBuf(can_id, 0, can_dlc, data);
  if (status == CAN_OK) {
    Serial.println("Success");
   } else
    Serial.println("Error");
}

void purseCounter() {
  elapsedTime = micros() - prevTime;
  prevTime = micros();

  if (purseCnt >= readingCnt) {
    elapsedTimeAvg = elapsedTimeSum / readingCnt;
    purseCnt = 1;
    elapsedTimeSum = elapsedTime;

    int tmpReadCnt = map(elapsedTime, 40000, 5000, 1, 10);
    readingCnt = constrain(tmpReadCnt, 1, 10);
  } else {
    purseCnt++;
    elapsedTimeSum += elapsedTime;
  }
}
