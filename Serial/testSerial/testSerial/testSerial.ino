 #include <FastLED.h>

FASTLED_USING_NAMESPACE
 #define DATA_PIN    7 //Pin for data on LedStrip
//#define CLK_PIN   4
#define LED_TYPE    WS2811
#define COLOR_ORDER GRB
#define NUM_LEDS    128
CRGB leds[NUM_LEDS];
#define LED 2 
#define BRIGHTNESS          96
#define FRAMES_PER_SECOND  120
 char val; // Data received from the serial port
 int ledPin = 13; // Set the pin to digital I/O 
 
 void setup() {
   pinMode(LED,OUTPUT);
   
   FastLED.addLeds<LED_TYPE,DATA_PIN,COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);
   // set master brightness control
   FastLED.setBrightness(BRIGHTNESS);
   Serial.begin(9600); // Start serial communication at 9600 bps
 }

  void loop() {
   if (Serial.available()) 
   { // If data is available to read,
     val = Serial.read(); // read it and store it in val
   }
//   if (val == '1') 
//   { // If 1 was received
//    leds[1]= CRGB::White; // turn the LED on
//   } else {
//    leds[1] = CRGB::Red; // otherwise turn it off
//   }
   println(val);
   FastLED.show();      
   delay(10); // Wait 10 milliseconds for next reading
}
