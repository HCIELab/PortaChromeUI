Canvas canvas = new Canvas();

void setup() {

  // pixelDensity(displayDensity());
  pixelDensity(1);
  colorMode(RGB, 255, 255, 255);
  noStroke();
  background(255);
  size(1600, 900);
  canvas.drawGUI();


}

void draw() {
  // background(255);
  canvas.updateGUI();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  brush.radius += (int)e;
}

void keyPressed() {
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