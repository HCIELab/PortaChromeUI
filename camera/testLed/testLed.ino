#include <FastLED.h>

FASTLED_USING_NAMESPACE

// FastLED "100-lines-of-code" demo reel, showing just a few 
// of the kinds of animation patterns you can quickly and easily 
// compose using FastLED.  
//
// This example also shows one easy way to define multiple 
// animations patterns and have them automatically rotate.
//
// -Mark Kriegsman, December 2014


#define DATA_PIN    7 //Pin for data on LedStrip
//#define CLK_PIN   4
#define LED_TYPE    WS2811
#define COLOR_ORDER GRB
#define NUM_LEDS    128
CRGB leds[NUM_LEDS];
#define LED 2 
#define BRIGHTNESS          96
#define FRAMES_PER_SECOND  120

void setup() {
  pinMode(LED,OUTPUT);
  delay(3000); // 3 second delay for recovery
  
  // tell FastLED about the LED strip configuration
  FastLED.addLeds<LED_TYPE,DATA_PIN,COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);
  //FastLED.addLeds<LED_TYPE,DATA_PIN,CLK_PIN,COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);

  // set master brightness control
  FastLED.setBrightness(BRIGHTNESS);
}


void loop() {
  for (int i = 1; i < NUM_LEDS; i++) {
    digitalWrite(LED,HIGH); // Turn on LED  
    delay(200);
    leds[i] = CRGB::White;  //set the all leds to blue
    leds[i-1] = CRGB::Black; 
    FastLED.show();
    delay(200); // 500ms   
    digitalWrite(LED,LOW); // Turn off LED  
  }
  FastLED.show();       //start the leds
  delay(50);
}
