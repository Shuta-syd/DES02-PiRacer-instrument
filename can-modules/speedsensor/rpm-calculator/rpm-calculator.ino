/*Includes*/
#include <SPI.h>  // SPI Communication
#include <mcp_can.h>  // MCP2515 CAN controller (CAN Bus) 

/*Constants*/
#define SPEED_SENSOR_PIN 2              // Encoder Signal Input = D2
#define WHEEL_DIAMETER 65.0             // Wheel diameter [mm]
#define SPEED_SENSOR_DISC_DIAMETER 20.0 // Speed sensor diameter [mm]
#define RPM_SENSOR_MAX 1800            // Max. RPM of sensor [1/min]
/*Variables*/
unsigned short rpm_sensor; 
unsigned short rpm_wheel; 
volatile byte pulses;
unsigned long millis_before;
double sample_rate;                     // sample rate in ms (the time between two calculations)
const unsigned int pulse_per_turn = 20;       // Speedsensor Disc Resolution = 20 slots
uint8_t data[8];                        // CAN message data
const int can_id = 0x125;                     // CAN message ID
const int can_dlc = 8;                        // CAN message data length
int can_status;                         // CAN status

MCP_CAN CAN(10);                        // Pin definition for CAN module

/*Setup, runs once after the Code starts.*/
void setup() {
  rpm_sensor = 0;
  pulses = 0;
  millis_before = 0;
  rpm_wheel = 0; 
  sample_rate = (1/(2*(RPM_SENSOR_MAX/60)))*1000; // calculate sample rate (Nyquist) in ms
  Serial.begin(9600);
  pinMode(SPEED_SENSOR_PIN, INPUT);
  // attach interrupt to pin 2 with ISR function count and trigger on falling edge
  attachInterrupt(digitalPinToInterrupt(SPEED_SENSOR_PIN), count, FALLING);
  // Initialize MCP2515 running at 8MHz with a baudrate of 125kb/s and the masks and filters disabled.
  // can set normal mode to send data.
  CAN.begin(MCP_ANY, CAN_125KBPS, MCP_8MHZ);
  CAN.setMode(MCP_NORMAL);
  can_status = 0; 
}

/*ISR to count the pulses*/
void count() {
  // increas pulse counter for each interrupt
  pulses++;
}

/*calculate rpm of sensor*/
void calculation_rpm_sensor() {
  // run for sample rate
  if (millis() - millis_before >= sample_rate) {
    //Interrupts are disabled to prevent the pulse counter from being changed during the calculation
    detachInterrupt(digitalPinToInterrupt(SPEED_SENSOR_PIN)); 
    // calculate rpm of sensor
    rpm_sensor = (60*1000/pulse_per_turn) / (millis() - millis_before) * pulses;
    // save time when the last calculation was done
    millis_before = millis(); 
    // reset pulse counter 
    pulses = 0; 
    // Interrupts are enabled again
    attachInterrupt(digitalPinToInterrupt(SPEED_SENSOR_PIN), count, FALLING);
    }
}

/*send rpm of wheel to CAN*/
void send_to_CAN() {
  data[0] = (rpm_wheel >> 8) & 0xFF;      // shift 8 bits to the right and mask with 0xFF to get the first byte
  data[1] = rpm_wheel & 0xFF;             // mask with 0xFF to get the second byte
  int can_status = CAN.sendMsgBuf(can_id, CAN_STDID ,can_dlc, data);
}

/*calculate RPM of wheel depending ration diameter of sensor disc to wheel*/
void calc_rpm_wheel() {
  rpm_wheel = (rpm_sensor * (SPEED_SENSOR_DISC_DIAMETER / WHEEL_DIAMETER)); 
}

/*print rpm of sensor and wheel to terminal*/
void print_terminal()
{
  Serial.print(" rpm_sensor: ");
  Serial.print(rpm_sensor);
  Serial.print(" rpm_wheel: ");
  Serial.print(rpm_wheel);
  if (can_status == CAN_OK) {
    Serial.println(" Status Bus: Send successfully.");
  } else{
    Serial.println(" Status Bus: Send failed.");
  } 
}

void loop() {
  calculation_rpm_sensor();
  calc_rpm_wheel();
  send_to_CAN();
  print_terminal();
}

