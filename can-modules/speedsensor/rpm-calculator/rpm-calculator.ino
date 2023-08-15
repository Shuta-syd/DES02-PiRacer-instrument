/*Final Version for Speed Sensor*/
/*
This code is used to calculate the RPM of the wheel and the speed of the vehicle. 
The rpm in 1/min and speed in m/min will be sent via CAN BUS to the piracer_py Application. 
*/

// MCP2515 CAN controller(CAN bus) and SPI communication
#include <SPI.h>
#include <mcp_can.h>

#define encoder_pin 2 //Encoder Signal Input = D2
unsigned short rpm_sensor; 
unsigned short rpm_wheel; 
unsigned short speed; 
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
  //Interrupts are disabled to prevent the pulse counter from being changed during the calculation
  detachInterrupt(digitalPinToInterrupt(encoder_pin)); 
  rpm_sensor = (60*1000/pulse_per_turn) / (millis() - TIME) * pulses;
  TIME = millis();
  pulses = 0;
  // Interrupts are enabled again
  attachInterrupt(digitalPinToInterrupt(encoder_pin), count, FALLING);
  }
}

void calc_for_wheel() {
  rpm_wheel = (rpm_sensor * (SpeedSensorDiameter / WheelDiameter)); // calculate RPM of wheel
  speed = rpm_wheel * circumference; // calculate speed
}

void send_to_CAN() {
  /*Car at full speed can reach up to rpm_sensor = 1500 1/min. 
  rpm_sensor generates the highest value. 
  Using usigned short (16 bits, value range: 0 - 65535) is enough to store all speed related values.
  The CAN message can only send 8 bytes at a time.
  Therefore, the 2x8 Bit long rpm_sensor and rpm_wheel values must be divided into two bytes each.
  To get the first 8 Bits of the values, we shift the value 8 Bits to the right and mask with 0xFF (1111 1111 bin) to keep only the last 8 bits. 
  To get the last 8 Bits of the values, we mask with 0xFF (1111 1111 bin) to keep only the last 8 bits.
  Than the values are stored in the data array. 
  The first two bytes of the data array are the speed value.
  The second two bytes of the data array are the rpm_wheel value.
  */ 

  data[0] = (speed >> 8) & 0xFF; 
  data[1] = speed & 0xFF; 
  data[2] = (rpm_wheel >> 8) & 0xFF;
  data[3] = rpm_wheel & 0xFF; 
  // send data:  ID = 0x125, Standard CAN Frame, Data length = 8 bytes, 'data' = array of data bytes to send
  int can_status = CAN.sendMsgBuf(can_id, CAN_STDID ,can_dlc, data);
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
    Serial.println(" Status Bus: Send successfully");
  } else{
    Serial.println(" Status Bus: Send failed");
  } 
}
