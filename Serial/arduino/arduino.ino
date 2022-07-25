//LOCAL

#include <Adafruit_NeoPixel.h>
//#include "BluetoothSerial.h"

// prepare enough resources for the neopixels
// here we first prepare 30 strips that are available for assignment
// this corresponds 30 different data pins, which is more than enough
Adafruit_NeoPixel AVAILABLE_NEOPIXEL_OBJECTS[] = {
Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), 
Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), 
Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), Adafruit_NeoPixel(), 
};

// each data pin can control up to 200 LEDs by default
// can change in the setup code or loop
#define STRIP_LED_COUNT 200

// array of pin numbers that are used
// as data pins for the fibers when there are multiple fibers
// subject to change
const int DATA_PIN_ARRAY[] = {0, 2, 4, 5, 12, 13, 14, 16, 17, 18, 19, 21, 22, 23, 25, 26, 27, 32, 33};
const int NUM_DATA_PIN = sizeof(DATA_PIN_ARRAY) / sizeof(DATA_PIN_ARRAY[0]);

// the neopixel strips that are actually available due to the restriction of the data pins
Adafruit_NeoPixel neopixel_object_array[NUM_DATA_PIN]; 

//initialize bluetooth classic
#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
//#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

#define BLUETOOTH_SERVER_NAME "/dev/tty.usbmodem141101" //"ESP32BluetoothTest1"

bool blt_enabled = false; // turn it to false if not using bluetooth communication
//BluetoothSerial SerialBT;

void setup() {  
  // Initialize the Neopixel Arrays
  // assign the correct data pins to each of the strip
  for (int i = 0; i < NUM_DATA_PIN; i++) {
    neopixel_object_array[i] = AVAILABLE_NEOPIXEL_OBJECTS[i]; // slot the corresponding object reference to the array that we actually use
    int data_pin = DATA_PIN_ARRAY[i]; 
    neopixel_object_array[i].setPin(data_pin);
    neopixel_object_array[i].updateLength(STRIP_LED_COUNT);
  }
  
  // Initializes the LEDs
  for(int i=0; i < NUM_DATA_PIN; i++){
      neopixel_object_array[i].begin();  
      neopixel_object_array[i].clear();           
      neopixel_object_array[i].show();            
    };

  // Initializes bluetooth
  Serial.begin(115200); // start the serial monitor for debugging purpose
//  SerialBT.begin(BLUETOOTH_SERVER_NAME); // Bluetooth device name
//  
//  if(blt_enabled){
//    SerialBT.println("The device started on the serial Bluetooth, now you can pair it with bluetooth!"); 
//    Serial.println("The device started on the serial Bluetooth, now you can pair it with bluetooth!");
//  }else{
//    Serial.println("The device started on the serial port, now you can pair it with bluetooth!");
//  }
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
  
  int i = 0;
  
//  while(blt_enabled && SerialBT.available() || !(blt_enabled) && Serial.available()){
//    
////        String fiber = blt_enabled ? SerialBT.readStringUntil('*') : Serial.readStringUntil('*');
//        
//        while(fiber.indexOf('#') != -1){
//          int index = fiber.indexOf('#');
//          String input = fiber.substring(0,index);
//          fiber.remove(0,index + 1);
//    
//          if (input[0] == 'd') {
//            
//            // display mode start
//            neopixel_object_array[i].clear();
//            currentIndex = 0;
//            currentMode = 0;
//            
//            }
//          else if (input[0] == 'v') {
//            
//            // visible light deactivation start
//            // read the next three digits to figure out how many pixels we have
//            actualNumPixel = input.substring(1,4).toInt();
//            neopixel_object_array[i].clear();
//            currentIndex = 0;
//            currentMode = 1;
//            hasInitialized = false;
//            
//            } else {
//            // now we read color values 
//            
//            if (currentMode == 0) { 
//              // display mode
//              int red = input.substring(0, 3).toInt();
//              int green = input.substring(4, 7).toInt();
//              int blue = input.substring(8, 11).toInt();
//              neopixel_object_array[i].setPixelColor(currentIndex, red, green, blue);
//              currentIndex += 1;
//            }
//      
//            else if (currentMode == 1) {
//              // deactivation mode, using visible light
//              // reading in deactivation time value
//              int red_time = input.substring(0, 3).toInt();
//              int green_time = input.substring(4, 7).toInt();
//              int blue_time = input.substring(8, 11).toInt();
//      
//              // populate the timer
//              RGB_timer timer = {red_time * 1000, green_time * 1000, blue_time * 1000};        
//              desaturationTimerMillisecond[currentIndex] = timer;
//              currentIndex += 1;
//            }
//            }
          };
    
        // deactivation mode + have read everything
        if (currentMode == 1 && currentIndex == actualNumPixel) {
          // if everything has been stored in the timer
          // start displaying
          for (int i = 0; i < actualNumPixel; i++) {
            
            RGB_timer timer = desaturationTimerMillisecond[i];
  
//            
//            SerialBT.print(timer.r);
//            SerialBT.print(",");
//            SerialBT.print(timer.g);
//            SerialBT.print(",");
//            SerialBT.print(timer.b);
//            SerialBT.print("| ");
            
            desaturationTimerMillisecond[i].r = timer.r - timeSliceMillisecond;
            desaturationTimerMillisecond[i].g = timer.g - timeSliceMillisecond;
            desaturationTimerMillisecond[i].b = timer.b - timeSliceMillisecond;
    
//            SerialBT.print(timer.r);
//            SerialBT.print(",");
//            SerialBT.print(timer.g);
//            SerialBT.print(",");
//            SerialBT.print(timer.b);
//            SerialBT.print("; ");
//            
            
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
              neopixel_object_array[i].setPixelColor(i, r_color, g_color, b_color);
              }
            }
  
//            SerialBT.println(" end");
    
            neopixel_object_array[i].show();
            delay(timeSliceMillisecond);
    
            hasInitialized = true;
    
            // turn off the strip after shining it for the correct amount of time
            //  neopixel_object_array[i].clear();
            //  neopixel_object_array[i].show();
        }
        
      neopixel_object_array[i].show();
      i++;
    
  }
};



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
