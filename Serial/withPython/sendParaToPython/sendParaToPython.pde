import processing.net.*; 
Client myClient;
     
void setup() { 
    size(200, 200); 
    /* Connect to the local machine at port 50007
     *  (or whichever port you choose to run the
     *  server on).
     * This example will not run if you haven't
     *  previously started a server on this port.
     */
    myClient = new Client(this, "127.0.0.1", 50007);
    String s = "22,33,45#199,200,201#39,29,49#123,42,55#*";
    println("processing to python:"+s);
    myClient.write(s);
} 
     
void draw() { 
    //myClient.write("22,33,45");
  if (myClient != null) {
    String input = myClient.readStringUntil(byte('\n'));
    if(input !=null){
      println("Python to processing:"+input);
    }
  }
    //myClient.write("22,33,45"); // send whatever you need to send here
} 
