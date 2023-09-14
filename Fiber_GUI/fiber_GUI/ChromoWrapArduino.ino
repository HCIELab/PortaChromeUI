#include <Adafruit_NeoPixel.h>

#define LED_STRIP_PIN   4   // Pin for the RGB LED data
#define UV_PIN 14
#define STRIP_LED_COUNT 144
#define PREVIEW_PIN 16

#define UV_SATURATION_TIME 5000  
#define RGB_DESATURATION_TIME 0

Adafruit_NeoPixel strip(STRIP_LED_COUNT, LED_STRIP_PIN, NEO_GRB + NEO_KHZ800);

struct Color {
  int r;
  int g;
  int b;
};

Color DisplayArray[STRIP_LED_COUNT];
Color DeactivationArray[STRIP_LED_COUNT];
boolean previewing = true;
boolean color_reprogrammed = false;
int RGB_time = 0; 

void setup() {
  pinMode(UV_PIN, OUTPUT);
  pinMode(PREVIEW_PIN, INPUT);
  
  // Enables serial communication with the python code
  Serial.begin(9600); 
  strip.begin();           
  strip.show();  


  // set placeholders
    // Placeholder values, change as required
  Color R = {255, 0, 0};  // Red for DisplayArray
  Color G = {0, 255, 0};  // Green for DeactivationArray
  Color B = {0, 0, 255}; 
  Color Zero = {0,0,0};
  
  // Initialize DisplayArray with placeholder1 repeated 12 times
  for (int i = 0; i < STRIP_LED_COUNT; ++i) {
    DisplayArray[i] = {0,0,0};
  }

  // Initialize DeactivationArray with placeholder2 repeated 12 times
  for (int i = 0; i < STRIP_LED_COUNT; ++i) {
    DeactivationArray[i] = {0, 6*i, 0};
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
            processInput(input, DeactivationArray);
        }
    }

  if (previewing) {
    color_reprogrammed = false;
    // Previewing mode, show colors from DisplayArray
    for (int i = 0; i < STRIP_LED_COUNT; i++) {
      strip.setPixelColor(i, strip.Color(DisplayArray[i].r, DisplayArray[i].g, DisplayArray[i].b));
    }
    strip.show();
  } else {
    // Deactivation mode
    strip.clear();
    strip.show();
    
    if (color_reprogrammed == false) {
      // Turn UV_PIN to HIGH for 3 seconds
      digitalWrite(UV_PIN, HIGH);
      delay(UV_SATURATION_TIME); 
      digitalWrite(UV_PIN, LOW);
      
      // Now, display colors from DeactivationArray
      for (int i = 0; i < STRIP_LED_COUNT; i++) {
        strip.setPixelColor(i, strip.Color(DeactivationArray[i].r, DeactivationArray[i].g, DeactivationArray[i].b));
      }
      strip.show();
      delay(RGB_DESATURATION_TIME); // might be a variable, use UV at the moment as a placeholder
      strip.clear();
      strip.show();
      color_reprogrammed = true;
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

    if (ledNum < STRIP_LED_COUNT) { // Check to make sure we don't exceed the array size
      colorArray[ledNum] = {r, g, b};
      ledNum++;
    }
  }
  return;
}
