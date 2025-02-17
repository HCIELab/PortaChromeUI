// By Yixiao Kang(kyx999@sjtu.edu.cn)
// fiber_GUI.pde, init the whole program, some global variables are initialized here
// build the basic framework for processing setup() and draw()

import controlP5.*;
import processing.serial.*;
import processing.net.*; 

Client myClient;
Serial myPort; 
PrintWriter output;

// I list all boolean status which will be changed when using the application
// since we're doing serial handshaking, 
// we need to check if we've heard from the microcontroller
boolean firstContact = false;
boolean hideColorWheel = false;
// two color mode: 1. color wheel(true) 2. 4 color picker(false)
boolean isShowRealColor=false;
boolean hasFiber = false;
boolean testMode = false;
boolean enableSpeedControl = false;
int maxColorChangingTime = 0; // the max time bound set by slider
int colorChangingTime = 0; // the color changing time calculated by the solver.py
float rotateHexagon = 3.1415926/6 ; // change to 3.1415926/6 when dealing with 108 leds. 
ControlP5 cp5;
ColorWheel cw;
Canvas canvas = new Canvas();

class ColorTmp{
    int r;
    int g;
    int b;
    int rTime;
    int gTime;  
    int bTime;
    
    ColorTmp(int r, int g, int b, int rTime, int gTime, int bTime) {
        this.r = r;
        this.g = g;
        this.b = b;
        this.rTime = rTime;
        this.gTime = gTime;
        this.bTime = bTime;
    }
}

void setup() {
    pixelDensity(1);
    colorMode(RGB, 255, 255, 255);
    noStroke();
    background(255);
    size(600, 770);
    // output = createWriter("ledsOri.txt"); 
    
    printArray(Serial.list());
    // myClient is for python(preview function)
    myClient = new Client(this, "127.0.0.1", 50007); 
    // Open the port you are using at the rate you want: 
    // myPort is for arduino
    
    // test Mode with no arduino, disable myPort 
    if (testMode) {
        myPort = null;
    }
    else{
        // Open the port you are using at the rate you want: 
        // myPort is for arduino, for the Serial.list[1], the number is the port number of arduino
        myPort = new Serial(this, Serial.list()[11], 9600);
        myPort.bufferUntil('\n'); 

    }

    cp5 = new ControlP5(this);
    cw = cp5.addColorWheel("wheel")
       .setPosition(300, 405)
       ;
    readFibersFromFile();
    hasFiber = true;
    // cp5.addSlider("brushSize")
    //    .setPosition(BRUSH_SLIDRE_X, BRUSH_SLIDRE_Y)
    //    .setRange(0,MAX_BRUSH_SIZE)
    //    .setWidth(BRUSH_SLIDRE_WID)
    //    .setHeight(BRUSH_SLIDRE_HEIGHT)
    //    .setValue(20)
    //    ;
    
    cp5.addSlider("picRotation")
       .setPosition(IMG_ROTATE_SLIDER_X, IMG_ROTATE_SLIDER_Y)
       .setRange(0,MAX_ROTATE)
       .setWidth(IMG_ROTATE_SLIDER_WID)
       .setHeight(IMG_ROTATE_SLIDER_HEIGHT)
       .setValue(0)
       ;
    
    cp5.addSlider("picScale")
       .setPosition(IMG_SCALE_SLIDER_X, IMG_SCALE_SLIDER_Y)
       .setRange(MIN_SCALE,MAX_SCALE)
       .setWidth(IMG_SCALE_SLIDER_WID)
       .setHeight(IMG_SCALE_SLIDER_HEIGHT)
       .setValue(INIT_PIC_WIDTH)
       ;
    
    cp5.addSlider("imgX")
       .setPosition(IMGX_SLIDER_X, IMGX_SLIDER_Y)
       .setRange(MIN_X,MAX_X)
       .setWidth(IMGX_SLIDER_WID)
       .setHeight(IMGX_SLIDER_HEIGHT)
       .setValue((MIN_X + MAX_X) / 2)
       ;
    
    cp5.addSlider("imgY")
       .setPosition(IMGY_SLIDER_X, IMGY_SLIDER_Y)
       .setRange(MIN_Y, MAX_Y)
       .setWidth(IMGY_SLIDER_WID)
       .setHeight(IMGY_SLIDER_HEIGHT)
       .setValue((MIN_Y + MAX_Y) / 2)
       ;
 
    cp5.addSlider("maxColorChangingTime")
       .setPosition(MAX_COLOR_CHANGING_TIME_SLIDER_X, MAX_COLOR_CHANGING_TIME_SLIDER_Y)
       .setRange(MIN_COLOR_CHANGING_TIME, MAX_COLOR_CHANGING_TIME)
       .setWidth(MAX_COLOR_CHANGING_TIME_SLIDER_WID)
       .setHeight(MAX_COLOR_CHANGING_TIME_SLIDER_HEIGHT)
       .setValue((MIN_COLOR_CHANGING_TIME + MAX_COLOR_CHANGING_TIME) / 2)
       ;
    canvas.drawGUI();
}

void draw() {
    background(255);
    
    
    if (!testMode && myPort.available() > 0) 
    {  // If data is available,
       // String val = myPort.readStringUntil('\n');         // read it and store it in val
        //if (val!= "")println(val); //print it out in the console
    } 
    if(hideColorWheel)cw.hide();
    else cw.show();
    if (myClient != null) {
        String input = myClient.readStringUntil(byte('\n'));
        
        if (input != null) {
            if (input.endsWith("\n")) {
            input = input.substring(0, input.length() - 1);
            }
            println("input: " + input);
            colorChangingTime = Integer.parseInt(input);
            String[] lines = loadStrings("ledsDeactivate.txt");
            println("lines:" + lines[0]);
            
            updateFiberRealColor(lines[0]);
        }
    }
    canvas.updateGUI();
}

// update Fiber RealColor from the date received from solver.py
void updateFiberRealColor(String newColor) {
    
    // parse the string into an array of colors 
    String[] rgbs = newColor.split("#");
    // dispose the color in rgbs one by one 
    ArrayList<ColorTmp> newColors = new ArrayList<ColorTmp>();
    int m = 0;int n = 0;
    
    for (int i = 0; i < rgbs.length; i++) {
        String[] rgb = rgbs[i].split(",");
        if (rgb.length < 3)break;
        int r = Integer.valueOf(rgb[0]);
        int g = Integer.valueOf(rgb[1]);
        int b = Integer.valueOf(rgb[2]);
        int rTime = Integer.valueOf(rgb[3]);
        int gTime = Integer.valueOf(rgb[4]);
        int bTime = Integer.valueOf(rgb[5]);
        newColors.add(new ColorTmp(r,g,b,rTime,gTime,bTime));
    }
    canvas.allFibers.updateRealColor(newColors);
}


void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    brush.radius += (int)e;
}

void keyPressed() {
    if (img == null) {
        if (key == 'a' || key == 's' || key == 'd' || key == 'w' || key == 'q' || key == 'e' || key == 'r')return;
    }
    if (key == 'd') {
        img.changeImg(img.centerX + IMG_MOVE_SPEED,img.centerY,img.width,img.height);
    } 
    else if (key == 'a') {
        img.changeImg(img.centerX - IMG_MOVE_SPEED,img.centerY,img.width,img.height);
    }
    else if (key == 'w') {
        img.changeImg(img.centerX ,img.centerY - IMG_MOVE_SPEED ,img.width,img.height);
    } 
    else if (key == 's') {
        img.changeImg(img.centerX ,img.centerY + IMG_MOVE_SPEED ,img.width,img.height);
    }
    else if (key == 'q') {
        img.changeImg(img.centerX ,img.centerY  ,img.width - IMG_SCALE_SPEED,img.height - IMG_SCALE_SPEED);
    }
    else if (key == 'e') {
        img.changeImg(img.centerX ,img.centerY  ,img.width + IMG_SCALE_SPEED,img.height + IMG_SCALE_SPEED);
    }
    else if (key == 'r') {
        img.rotateAngle += IMG_ROTATE_SPEED;
    }
    else if (key == '1') {
        canvas.allFibers.drawSetting = 1;
    }
    else if (key == '2') {
        canvas.allFibers.drawSetting = 2;
    }
}

void mouseClicked() {
    canvas.addImgBtn.checkBtnClicked();
    canvas.brushBtn.checkBtnClicked();
    canvas.startBtn.checkBtnClicked();
    canvas.deactivateBtn.checkBtnClicked();
    // canvas.importBtn.checkBtnClicked();
    // canvas.colorModeBtn.checkBtnClicked();
    canvas.colorPickerCyanBtn.checkBtnClicked();
    canvas.colorPickerBlackBtn.checkBtnClicked();
    canvas.colorPickerYellowBtn.checkBtnClicked();
    canvas.colorPickerWhiteBtn.checkBtnClicked();
    canvas.speedControlBtn.checkBtnClicked();
}


void mouseDragged() {
    brush.drawWithBrush();
}


void serialEvent(Serial myPort) {
    //put the incoming data into a String - 
    //the '\n' is our end delimiter indicating the end of a complete packet
    String val = myPort.readStringUntil('\n');
    //make sure our data isn't empty before continuing
    if (val != null) {
        //trim whitespace and formatting characters (like carriage return)
        val = trim(val);
        //  println(val);
    }
}
