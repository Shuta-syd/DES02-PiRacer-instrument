  // MCP2515 CAN controller(CAN bus) and SPI communication
#include <SPI.h>
#include <mcp_can.h>

#define encoder_pin 2 //Encoder Signal Input = D2
unsigned long rpm_sensor;
unsigned long rpm_wheel;
unsigned long speed; 
volatile byte pulses;
unsigned long TIME;
unsigned int pulse_per_turn = 20; //Encoder Disc Resolution = 20 slots
double circumference ; // Wheel circumference [m]
#define PI 3.1415926535897932384626433832795
#define WheelDiameter 65.0 // Wheel diameter [mm]
#define SpeedSensorDiameter 20.0 // Speed sensor diameter [mm]
uint8_t data[8];
int can_id = 0x125;
int can_dlc = 8;
// Pin definition for CAN module
MCP_CAN CAN(10);
int can_status; 
  
void count() {
  pulses++;
}

void setup() {
  // Sensor RPM
  rpm_sensor = 0;
  pulses = 0;
  TIME = 0;
  // Wheel RPM & speed
  circumference = WheelDiameter * PI / 1000; // Wheel circumference [m]
  rpm_wheel = 0; 
  speed = 0; 
  // Serial Monitor
  Serial.begin(9600);
  // Speed Sensor 
  pinMode(encoder_pin, INPUT);
  attachInterrupt(digitalPinToInterrupt(encoder_pin), count, FALLING);
  // CAN Modul
  // Initialize MCP2515 running at 8MHz with a baudrate of 125kb/s and the masks and filters disabled.
  CAN.begin(MCP_ANY, CAN_125KBPS, MCP_8MHZ);
  // can set normal mode to send data.
  CAN.setMode(MCP_NORMAL);
  can_status = 0; 
}

void read_sensor_rpm() {
if (millis() - TIME >= 100) {
  detachInterrupt(digitalPinToInterrupt(encoder_pin));
  rpm_sensor = (60*1000/pulse_per_turn) / (millis() - TIME) * pulses;
  TIME = millis();
  pulses = 0;

  attachInterrupt(digitalPinToInterrupt(encoder_pin), count, FALLING);
  }
}

void calc_for_wheel() {
  rpm_wheel = (rpm_sensor * (SpeedSensorDiameter / WheelDiameter)); // calculate RPM of wheel
  speed = rpm_wheel * circumference; // calculate speed
}

void send_to_CAN() {
  // CAN Bus
  data[0] = (speed >> 8) & 0xFF;
  data[1] = speed & 0xFF;
  data[2] = (rpm_wheel >> 8) & 0xFF;
  data[3] = rpm_wheel & 0xFF;
  int can_status = CAN.sendMsgBuf(can_id, CAN_STDID ,can_dlc, data);
  //memcpy(data, &RPM_w, 8);
  //memcpy(data, &speed, 8);
  //int status = CAN.sendMsgBuf(can_id, 0, can_dlc, data);
  // check if data was sent successfully
}

void loop() {
  read_sensor_rpm();
  calc_for_wheel();
  send_to_CAN(); 

  Serial.print(" rpm_sensor: ");
  Serial.print(rpm_sensor);
  Serial.print(" rpm_wheel: ");
  Serial.print(rpm_wheel);
  Serial.print(" speed: ");
  Serial.print(speed);
  
    if (can_status == CAN_OK) {
    Serial.println("Success");
   } else
    Serial.println("Error");
}
