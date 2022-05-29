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
    if(img != null) image(img, centerX - width / 2, centerY - height / 2, width, height); 
  }
  void drawImgOnPg(PGraphics pg) {
    pg.image(img, centerX - width / 2 - PAINT_WIN_LEFT_TOP_X , centerY - height / 2 -PAINT_WIN_LEFT_TOP_Y , width, height); 
  }
  
}

