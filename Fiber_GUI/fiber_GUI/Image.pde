// By Yixiao Kang(kyx999@sjtu.edu.cn)
// define the Image class, we can add image to the canvas, but now we delete this function, 
// you can go to the https://github.com/echo-xiao9/FiberGUI to see the previous version with image function

class Img{
  PImage img;
  int centerX;
  int centerY;
  int width;
  int height;
  float rotateAngle;

  Img(PImage img1, int centerX1, int centerY1, int width1, int height1) {
    img = img1;
    centerX = centerX1;
    centerY = centerY1;
    width = width1;
    height = height1;
    rotateAngle = 0.0f;
    img.resize(width1, height1);
  }

  void changeImg(int centerX1, int centerY1, int width1, int height1) {
    centerX = centerX1;
    centerY = centerY1;
    width = width1;
    height = height1;
    img.resize(width, height);
  }

  void changeImgSize( int newWid) {

    height = height * newWid/width;
    width = newWid;
    img.resize(width, height);
    
  }

  void drawImg() {
    if(img != null) {
      image(img, centerX - width / 2, centerY - height / 2, width, height); 
    }
  }

  void drawImgOnPg(PGraphics pg) {
    pg.pushMatrix();
    pg.translate(centerX - PAINT_WIN_LEFT_TOP_X, centerY - PAINT_WIN_LEFT_TOP_Y );
    pg.rotate(rotateAngle);
    pg.image(img,  - width / 2  , - height / 2 , width, height); 
    pg.popMatrix();
  }
  
}

