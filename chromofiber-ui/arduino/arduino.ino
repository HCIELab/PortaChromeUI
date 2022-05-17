#include <Adafruit_NeoPixel.h>

#define LED_STRIP_PIN   4   // Pin for the RGB LED data
#define STRIP_LED_COUNT 200

Adafruit_NeoPixel strip(STRIP_LED_COUNT, LED_STRIP_PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  // Enables serial communication with the python code
  Serial.begin(9600);
  // Initializes the LEDs. The Strip should be intense, at maximum brightness, but the light we dim a little bit to extentuate the changes in the fiber. 
  strip.begin();           
  strip.show();            
  strip.setBrightness(100); 
}

struct RGB_timer {
  int r;
  int g;
  int b;
}; // in millisecond


// common variables
int currentMode = 0; // 0: "d" display, 1: "v" deactivate using visible color
int currentIndex = 0;

// variable for "v mode" deactivation only
int actualNumPixel = 60;
RGB_timer desaturationTimerMillisecond[STRIP_LED_COUNT];
int timeSliceMillisecond = 100;  // the time needed to refresh, in millisecond
boolean hasInitialized = false;

void loop() {
  
  // Command List:
  // "d" - desaturate: program RGB LED in a way that 
  // it shines specific light combination for 
  // a specific amount of time (or at specfic brightness)
  // "v" - visible light: desaturate color using visible light
  // input comes in (red shining time, green shining time, blue shining time) 
  while(Serial.available()){

    String input = Serial.readStringUntil('#');
    if (input[0] == 'd') {
      
      // display mode start
      strip.clear();
      currentIndex = 0;
      currentMode = 0;
      
      }
    else if (input[0] == 'v') {
      
      // visible light deactivation start
      // read the next three digits to figure out how many pixels we have
      actualNumPixel = input.substring(1,4).toInt();
      strip.clear();
      currentIndex = 0;
      currentMode = 1;
      hasInitialized = false;
      
      } else {
      // now we read color values 
      
      if (currentMode == 0) { 
        // display mode
        int red = input.substring(0, 3).toInt();
        int green = input.substring(4, 7).toInt();
        int blue = input.substring(8, 11).toInt();
        strip.setPixelColor(currentIndex, red, green, blue);
        currentIndex += 1;
      }

      else if (currentMode == 1) {
        // deactivation mode, using visible light
        // reading in deactivation time value
        int red_time = input.substring(0, 3).toInt();
        int green_time = input.substring(4, 7).toInt();
        int blue_time = input.substring(8, 11).toInt();

        // populate the timer
        RGB_timer timer = {red_time * 1000, green_time * 1000, blue_time * 1000};        
        desaturationTimerMillisecond[currentIndex] = timer;
        currentIndex += 1;
      }
      }
    }

    // deactivation mode + have read everything
    if (currentMode == 1 && currentIndex == actualNumPixel) {
      // if everything has been stored in the timer
      // start displaying
      for (int i = 0; i < actualNumPixel; i++) {
        
        RGB_timer timer = desaturationTimerMillisecond[i];

        Serial.print(timer.r);
        Serial.print(",");
        Serial.print(timer.g);
        Serial.print(",");
        Serial.print(timer.b);
        Serial.print("| ");
        
        desaturationTimerMillisecond[i].r = timer.r - timeSliceMillisecond;
        desaturationTimerMillisecond[i].g = timer.g - timeSliceMillisecond;
        desaturationTimerMillisecond[i].b = timer.b - timeSliceMillisecond;

        Serial.print(timer.r);
        Serial.print(",");
        Serial.print(timer.g);
        Serial.print(",");
        Serial.print(timer.b);
        Serial.print("; ");

        // find out whether anything changed
        if ( timer.r > 0 && timer.r <= timeSliceMillisecond ||
             timer.g > 0 && timer.g <= timeSliceMillisecond ||
             timer.b > 0 && timer.b <= timeSliceMillisecond ||
             !hasInitialized 
             ) {

          // refresh color 
          int r_color = timer.r > timeSliceMillisecond ? 255 : 0;
          int g_color = timer.g > timeSliceMillisecond ? 255 : 0;
          int b_color = timer.b > timeSliceMillisecond ? 255 : 0;
          strip.setPixelColor(i, r_color, g_color, b_color);
          }
        }

        Serial.println(" end");

        strip.show();
        delay(timeSliceMillisecond);

        hasInitialized = true;

        // turn off the strip after shining it for the correct amount of time
//        strip.clear();
//        strip.show();
    }
    
  strip.show();
}




//static void setColors (int numPixels, uint32_t shining_time_millisecond[]){
//  // find the max-shining time
//  uint32_t max_shining_time_millisecond = 0;
//  for (int i = 0; i < numPixels; i++) {
//      if (shining_time_millisecond[i] > max_shining_time_millisecond) {
//        max_shining_time_millisecond =  shining_time_millisecond[i];
//      }
//  }
//  
//  for (int i = 0; i < numPixels; i++) {
//    uint8_t intensity = floor((255 * shining_time_millisecond[i] / max_shining_time_millisecond));
//    strip.setPixelColor(i, 0, intensity, 0);
//  }
//  strip.show();
//  delay(max_shining_time_millisecond);
//
//  // turn off the strip after shining it for the correct amount of time
//  strip.clear();
//  strip.show();
//}
