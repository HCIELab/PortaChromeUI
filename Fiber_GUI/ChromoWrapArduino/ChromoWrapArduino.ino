#include <Adafruit_NeoPixel.h>

#define LED_STRIP_PIN   4   // Pin for the RGB LED data
#define UV_PIN 14
#define STRIP_LED_COUNT 36
#define PREVIEW_PIN 16

#define UV_SATURATION_TIME 0  
#define RGB_DESATURATION_TIME 0


Adafruit_NeoPixel strip(STRIP_LED_COUNT, LED_STRIP_PIN, NEO_GRB + NEO_KHZ800);

struct Color {
  int r;
  int g;
  int b;
};

Color DisplayArray[STRIP_LED_COUNT];
Color DeactivationTimeArray[STRIP_LED_COUNT];
Color DeactivationColorArray[STRIP_LED_COUNT];

boolean previewing = true;
boolean reprogram_started = false;
int RGB_time = 0; 
int maximum_time = 0;
unsigned long startTime = 0; // timer for RGB desaturation delay
unsigned long lastUpdate = 0; // timer for RGB desaturation delay


void setup() {
  pinMode(UV_PIN, OUTPUT);
  pinMode(PREVIEW_PIN, INPUT);
  
  // Enables serial communication with the python code
  Serial.begin(9600); 
  strip.begin();           
  strip.show();  

  // Initialize DisplayArray with placeholder
  for (int i = 0; i < STRIP_LED_COUNT; ++i) {
    DisplayArray[i] = {0,125,0};
  }

  // Initialize DeactivationArray with placeholder
  for (int i = 0; i < STRIP_LED_COUNT; ++i) {
    DeactivationTimeArray[i] = {i, i, 0};
  }

}

void loop() {
  previewing = (digitalRead(PREVIEW_PIN) == HIGH); 
  // Command List:
  // "d" - desaturate: program RGB LED in a way that 
  // it shines specific light combination for 
  // a specific amount of time (or at specfic brightness)
  // "v" - visible light: desaturate color using visible light
  // input comes in (red shining time, green shining time, blue shining time) 
    while(Serial.available()){      
      strip.clear();
      Serial.print("available");
      
      String input = Serial.readStringUntil('*');
        if (input.startsWith("d#")) {
            input.remove(0, 2); // Remove the initial "d#" from the string
            processInput(input, DisplayArray);
          }
        else if (input.startsWith("v#")) {
            input.remove(0, 2); // Remove the initial "v#" from the string
            maximum_time = 0;
            processInput(input, DeactivationTimeArray);
            processDeactivationTimes();
        }
    }

  if (previewing) {
    reprogram_started = false;
    // Previewing mode, show colors from DisplayArray
    for (int i = 0; i < STRIP_LED_COUNT; i++) {
      strip.setPixelColor(i, strip.Color(DisplayArray[i].r, DisplayArray[i].g, DisplayArray[i].b));
    }
    strip.show();
  } else {
    // Deactivation mode
    strip.clear();

    unsigned long now = millis();

    if (reprogram_started == false) {
      startTime = now;
      reprogram_started = true;
    }
    
    if (now - lastUpdate >= 1000) { 
      lastUpdate = now;
      unsigned long time_programmed = now - startTime;

       for (int i = 0; i < STRIP_LED_COUNT; ++i) {
        // turn on and off light based on whether the time has passed
        // the required time is larger than the time passed
        // then stay on
        int r = DeactivationTimeArray[i].r * 1000 > time_programmed ? 255 : 0;
        int g = DeactivationTimeArray[i].g * 1000 > time_programmed ? 255 : 0;
        int b = DeactivationTimeArray[i].b * 1000 > time_programmed ? 255 : 0;

        strip.setPixelColor(i, r, g, b); 
       }
         
      strip.show();
    }
  }
}


void processInput(String &input, Color colorArray[]) {
  int ledNum = 0; // Counter for the number of LEDs processed
  int hashPos = 0, commaPos = 0;

  // Resetting all colors in the array to (0,0,0)
  for (int i = 0; i < STRIP_LED_COUNT; i++) {
    colorArray[i] = {0, 0, 0};
  }

  while ((hashPos = input.indexOf('#')) != -1) {
    String colorString = input.substring(0, hashPos);
    input.remove(0, hashPos + 1);

    int r = colorString.substring(0, commaPos = colorString.indexOf(',')).toInt();
    colorString.remove(0, commaPos + 1);
    int g = colorString.substring(0, commaPos = colorString.indexOf(',')).toInt();
    colorString.remove(0, commaPos + 1);
    int b = colorString.toInt();

    maximum_time = max(maximum_time, max(r, max(g,b)));
    if (ledNum < STRIP_LED_COUNT) { // Check to make sure we don't exceed the array size
      colorArray[ledNum] = {r, g, b};
      ledNum++;
    }
  }
  return;
}
 
void processDeactivationTimes() {
  for (int i = 0; i < STRIP_LED_COUNT; i++) {
     Color c = DeactivationTimeArray[i]; // actually it refers to a triplet of time in seconds
     int r = c.r;
     int g = c.g;
     int b = c.b;
     DeactivationColorArray[i] = {map(r, 0, maximum_time, 0, 255), map(g, 0, maximum_time, 0, 255), map(b, 0, maximum_time, 0, 255)};
  }
}
