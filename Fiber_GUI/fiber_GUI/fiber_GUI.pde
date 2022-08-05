import controlP5.*;
import processing.serial.*;
import processing.net.*; 

Client myClient;
Serial myPort; 
PrintWriter output;


// since we're doing serial handshaking, 
// we need to check if we've heard from the microcontroller
boolean firstContact = false;

ControlP5 cp5;
ColorWheel cw;
Canvas canvas = new Canvas();

class ColorTmp{
    int r;
    int g;
    int b;
    
    ColorTmp(int r, int g, int b) {
        this.r = r;
        this.g = g;
        this.b = b;
    }
}

void setup() {
    pixelDensity(1);
    colorMode(RGB, 255, 255, 255);
    noStroke();
    background(255);
    size(1400, 800);
    output = createWriter("ledsOri.txt"); 
    
    printArray(Serial.list());
    myClient = new Client(this, "127.0.0.1", 50007); 
    // Open the port you are using at the rate you want:
    myPort = new Serial(this, Serial.list()[3], 9600);
    myPort.bufferUntil('\n'); 
    
    
    cp5 = new ControlP5(this);
    cw = cp5.addColorWheel("wheel")
       .setPosition(1150, 200)
       ;
    
    cp5.addSlider("brushSize")
       .setPosition(BRUSH_SLIDRE_X, BRUSH_SLIDRE_Y)
       .setRange(0,MAX_BRUSH_SIZE)
       .setWidth(BRUSH_SLIDRE_WID)
       .setHeight(BRUSH_SLIDRE_HEIGHT)
       .setValue(20)
       ;
    
    cp5.addSlider("picRotation")
       .setPosition(PICROTATION_SLIDER_X, PICROTATION_SLIDER_Y)
       .setRange(0,MAX_ROTATE)
       .setWidth(PICROTATION_SLIDER_WID)
       .setHeight(PICROTATION_SLIDER_HEIGHT)
       .setValue(0)
       ;
    
    cp5.addSlider("picScale")
       .setPosition(PICSCALE_SLIDER_X, PICSCALE_SLIDER_Y)
       .setRange(MIN_SCALE,MAX_SCALE)
       .setWidth(PICSCALE_SLIDER_WID)
       .setHeight(PICSCALE_SLIDER_HEIGHT)
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
    
    canvas.drawGUI();
}

void draw() {
    canvas.updateGUI();
    
    if (myPort.available() > 0) 
    {  // If data is available,
        String val = myPort.readStringUntil('\n');         // read it and store it in val
        if (val!= "")println(val); //print it out in the console
    } 
    if (myClient != null) {
        String input = myClient.readStringUntil(byte('\n'));
        
        if (input != null) {
            println("input: " + input);
            String[] lines = loadStrings("ledsDeactivate.txt");
            println("lines:" + lines[0]);
            
            updateFiberRealColor(lines[0]);
        }
    }
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
        newColors.add(new ColorTmp(r,g,b));
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
    canvas.importBtn.checkBtnClicked();
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