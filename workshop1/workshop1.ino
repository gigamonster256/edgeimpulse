/*
Arudino Code created for the ARM x IEEE Workshop
Author: Akshat Nerella
Purpose: The code forwards all accelerometer outputs in a tsv format
for the data forwarder to forward this data to the Edge Impulse CLI
*/

#include <Adafruit_MMA8451.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

Adafruit_MMA8451 mma = Adafruit_MMA8451();

void setup(void) {
  Serial.begin(15200);

  //  Serial.println("Adafruit MMA8451 test!");

  if (!mma.begin()) {
    //    Serial.println("Couldnt start");
    while (1)
      ;
  }
  //  Serial.println("MMA8451 found!");

  mma.setRange(MMA8451_RANGE_2_G);

  //  Serial.print("Range = "); Serial.print(2 << mma.getRange());
  //  Serial.println("G");
}

void loop() {
  // Read the 'raw' data in 14-bit counts
  mma.read();
  Serial.print(mma.x);
  Serial.print("\t");
  Serial.print(mma.y);
  Serial.print("\t");
  Serial.print(mma.z);
  Serial.println();
  delay(100);
}
