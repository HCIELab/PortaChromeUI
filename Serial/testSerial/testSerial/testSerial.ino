 #include <FastLED.h>
#define SERIAL_BUFFER_SIZE 2000


FASTLED_USING_NAMESPACE
 #define DATA_PIN    7 //Pin for data on LedStrip
//#define CLK_PIN   4
#define LED_TYPE    WS2811
#define COLOR_ORDER GRB
#define NUM_LEDS    256
CRGB leds[NUM_LEDS];
#define LED 2 
#define BRIGHTNESS          96
#define FRAMES_PER_SECOND  120
String val; // Data received from the serial port
int ledPin = 13; // Set the pin to digital I/O 
int currentIndex = 0;


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
//     val = Serial.readString(); // read it and store it in val
      val =  Serial.readStringUntil('*');
   }
  currentIndex=0;
    while(val.indexOf('#') != -1){
      int index = val.indexOf('#');
      String ledRGB = val.substring(0,index);
      int index1 = ledRGB.indexOf(',', 0);
      int index2 = ledRGB.indexOf(',', index1+1);
      String r = ledRGB.substring(0,index1);
      String g = ledRGB.substring(index1+1, index2);
      String b = ledRGB.substring(index2+1);
      Serial.println("rgb"+r+" "+g+" "+b+"currentIndex:"+currentIndex);
  
      val.remove(0,index + 1);
      leds[currentIndex].setRGB(g.toInt(),r.toInt(),b.toInt());
      currentIndex += 1;
    }
//    if(currentIndex!=0){
//      Serial.println(currentIndex);
//    }

//   
//    for(int i =0; i<val.length();i++){
//      leds[i]= CRGB::White;
//    }
//    leds[4]=  CRGB::White;

   
//   Serial.write(val);
   FastLED.show();
//   Serial.print("hi");      
   delay(10); // Wait 10 milliseconds for next reading
}
