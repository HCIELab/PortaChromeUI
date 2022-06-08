
import controlP5.*;
ControlP5 cp5;
ColorWheel cw;
Canvas canvas = new Canvas();

void setup() {
  pixelDensity(1);
  colorMode(RGB, 255, 255, 255);
  noStroke();
  background(255);
  size(1400, 800);
  cp5 = new ControlP5(this);
  cw = cp5.addColorWheel("wheel")
        .setPosition(1100, 100);
  cp5.addSlider("brushSize")
     .setPosition(BRUSH_SLIDRE_X, BRUSH_SLIDRE_Y)
     .setRange(0,MAX_BRUSH_SIZE)
     .setWidth(BRUSH_SLIDRE_WID)
     .setHeight(BRUSH_SLIDRE_HEIGHT)
     .setValue(20)
     ;
  canvas.drawGUI();
}

void draw() {

  canvas.updateGUI();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  brush.radius += (int)e;
}

void keyPressed() {
  if(img == null) {
    if(key == 'a' || key == 's' || key == 'd' || key == 'w' || key == 'q' || key == 'e' || key == 'r')return;
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
    img.changeImg(img.centerX ,img.centerY  ,img.width-IMG_SCALE_SPEED,img.height- IMG_SCALE_SPEED);
  }
  else if (key == 'e') {
    img.changeImg(img.centerX ,img.centerY  ,img.width + IMG_SCALE_SPEED,img.height + IMG_SCALE_SPEED);
  }
  else if (key == 'r') {
    img.rotateAngle += IMG_ROTATE_SPEED;
  }

  else if (key == '1') {
    canvas.fibers.drawSetting = 1;
  }
  else if (key == '2') {
    canvas.fibers.drawSetting = 2;
  }
}

void mouseClicked() {
  canvas.addImgBtn.checkBtnClicked();
  canvas.brushBtn.checkBtnClicked();
  canvas.startBtn.checkBtnClicked();
}

void mouseDragged(){
  brush.drawWithBrush();
}


 