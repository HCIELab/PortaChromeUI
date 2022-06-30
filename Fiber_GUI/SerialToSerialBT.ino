// SAMPLE CODE FOR BLUETOOTH CLASSIC

// Port this code to your ESP32 to start its bluetooth.
// After doing this, you will be able to find this device 
//    in your computer's bluetooth list (might need to wait for a couple of minutes)
// You need to click "connect to device" in order for it to show up as a port.
// Then you can do the same thing to it like what you did with an USB port.

#include "BluetoothSerial.h"
#include <Adafruit_NeoPixel.h>

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

#define BLUETOOTH_SERVER_NAME "ESP32Bluetooth"
#define FIBER_DATA_PIN    4
#define STRIP_LED_COUNT   100

BluetoothSerial SerialBT;
Adafruit_NeoPixel fiber = Adafruit_NeoPixel(STRIP_LED_COUNT, FIBER_DATA_PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  // init bluetooth
  Serial.begin(115200); // start the serial monitor for debugging purpose
  SerialBT.begin(BLUETOOTH_SERVER_NAME); // Bluetooth device name
  Serial.println("The device started, now you can pair it with bluetooth!"); 

  // init neopixel
  fiber.begin();           
  fiber.show();            
  fiber.setBrightness(100); 
}

void loop() {
  if (Serial.available()) {
    // We are not using this
    // This from the original sample code
    // This is for sending data from the ESP32 to the computer
    SerialBT.write(Serial.read());
  }
  if (SerialBT.available()) {
    // this is the message that you read when
    // the other end does something like Serial.write()
    String content = SerialBT.readStringUntil('\n');
    Serial.println(content); // print the message it gets for debugging purpose

    // assuming the data looks like: "RRR,GGG,BBB"
    int red = content.substring(0, 3).toInt();
    int green = content.substring(4, 7).toInt();
    int blue = content.substring(8, 11).toInt();

    fiber.setPixelColor(0, red, green, blue); // set the fiber's first index to the specified color
    fiber.show();
  }
  delay(20);
}
