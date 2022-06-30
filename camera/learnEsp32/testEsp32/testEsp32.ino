/*  
* ESP32 LED Blink Example  
*/  
#define LED 2  
void setup() {  
 // Set pin mode  
 pinMode(LED,OUTPUT);  
}  
void loop() {  
 delay(500); // 500ms  
 digitalWrite(LED,HIGH); // Turn on LED  
 delay(500); // 500ms   
 digitalWrite(LED,LOW); // Turn off LED  
}  
