class Img{
  PImage img;
  int centerX;
  int centerY;
  int width;
  int height;
  Img(PImage img1, int centerX1, int centerY1, int width1, int height1) {
    img = img1;
    centerX = centerX1;
    centerY = centerY1;
    width = width1;
    height = height1;
    img.resize(width1, height1);
  }
  void changeImg(int centerX1, int centerY1, int width1, int height1) {
    centerX = centerX1;
    centerY = centerY1;
    width = width1;
    height = height1;
    img.resize(width, height);
  }
  void drawImg() {
    image(img, centerX - width / 2, centerY - height / 2, width, height); 
  }
  void drawImgOnPg(PGraphics pg) {
    pg.image(img, centerX - width / 2, centerY - height / 2, width, height); 
  }
  
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
  

}