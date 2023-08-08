// MCP2515 CAN controller(CAN bus) and SPI communication
#include <SPI.h>
#include <mcp_can.h>

// Pin definition for speed sensor
#define SPEED_SENSOR_PIN 2
// Pin definition for CAN module
MCP_CAN CAN(10);

/** values to calculate RPM */
#define PPR 20 // Pulses per revolution
#define PI 3.1415926535897932384626433832795
#define ZERO_TIMEOUT    100000  // Timeout period(microsecond) for RPM reset
#define WheelDiameter 65.0 // Wheel diameter [mm]
#define SpeedSensorDiameter 20.0 // Speed sensor diameter [mm]
double elapsedTimeAvg = 0.0; // elapsed time between two pulses
double elapsedTimeSum = 100000.0; // elaped time sum
double elapsedTime = 0; // elapsed time
double prevTime = 0; // previous time
unsigned long frqRaw = 0; // frequency
unsigned long RPM_s = 0; // Sensor Rotations per minute
unsigned long RPM_w = 0; // Wheel Rotations per minute
unsigned long speed = 0; // Speed [m/min]
int readingCnt = 1; // reading count
int purseCnt = 1; // pulse count


void setup() {
  Serial.begin(115200);
  pinMode(SPEED_SENSOR_PIN, INPUT);
  // Initialize MCP2515 running at 8MHz with a baudrate of 125kb/s and the masks and filters disabled.
  CAN.begin(MCP_ANY, CAN_125KBPS, MCP_8MHZ);
  // can set normal mode to send data.
  CAN.setMode(MCP_NORMAL);
  // attach interrupt to read speed sensor on rising edge
  attachInterrupt(digitalPinToInterrupt(SPEED_SENSOR_PIN), purseCounter, RISING);
}

void loop() {
  uint8_t data[8];
  int can_id = 0x125;
  int can_dlc = 8;
  double C = WheelDiameter * PI / 1000; // Wheel circumference [m]

  double prev_cycle_time = micros();
  double current_time = micros();
  frqRaw = 1000000 * 1000 / elapsedTimeAvg; // calculate RPM and speed from elapsed time

  if (elapsedTime > ZERO_TIMEOUT || (current_time - prev_cycle_time) > ZERO_TIMEOUT)
    frqRaw = 0;

  RPM_s = (frqRaw * 60 / PPR) / 1000; // calculate RPM of sensor
  RPM_w = RPM_s * (SpeedSensorDiameter / WheelDiameter); // calculate RPM of wheel
  speed = RPM_w * C; // calculate speed

  Serial.print("RPM: ");
  Serial.print(RPM_w);
  Serial.print(" Speed [m/min]: ");
  Serial.println(speed);
  // Store RPM_w in data array
  memcpy(data, &RPM_w, 8);
  // send data via CAN bus

  memcpy(data, &speed, 8);
  int status = CAN.sendMsgBuf(can_id, 0, can_dlc, data);
  // check if data was sent successfully
  if (status == CAN_OK) {
    Serial.println("Success");
   } else
    Serial.println("Error");
}

void purseCounter() {
  // calculate elapsed time between two pulses
  elapsedTime = micros() - prevTime;
  prevTime = micros();
  if (purseCnt >= readingCnt) {
    // calculate average elapsed time
    elapsedTimeAvg = elapsedTimeSum / readingCnt;
    purseCnt = 1;
    elapsedTimeSum = elapsedTime;
    // calculate reading count based on elapsed time
    int tmpReadCnt = map(elapsedTime, 40000, 5000, 1, 10);
    readingCnt = constrain(tmpReadCnt, 1, 10);
  } else {
    purseCnt++;
    elapsedTimeSum += elapsedTime;
  }
}
