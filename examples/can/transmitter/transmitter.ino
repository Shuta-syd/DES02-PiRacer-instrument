#include <mcp_can.h>
#include <SPI.h>

#define SENSOR_PIN 2

MCP_CAN CAN(10);
uint8_t count = 0;

void rpmCounter() {
 count++;
 Serial.println(count);
}

void setup() {

  Serial.begin(9600);

  CAN.begin(MCP_ANY, CAN_125KBPS, MCP_8MHZ);
  CAN.setMode(MCP_NORMAL);

  pinMode(SENSOR_PIN, INPUT);
  attachInterrupt(digitalPinToInterrupt(SENSOR_PIN), rpmCounter, RISING);
}

void loop() {

  uint8_t data[8];
  int can_id = 0x125;
  int can_dlc = 8;
  memcpy(data, &count, 8);

  int status = CAN.sendMsgBuf(can_id, 0, can_dlc, data);
  if (status == CAN_OK) {
    Serial.println("Success");
   } else
    Serial.println("Error");
  delay(1000);
}
