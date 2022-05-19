class Img{
  PImage img;
  int centerX;
  int centerY;
  float width;
  float height;
  Img(PImage img1, int centerX1, int centerY1, int width1, int height1){
    img = img1;
    centerX = centerX1;
    centerY = centerY1;
    width = width1;
    height = height1;
  }
  void changeImg(int centerX1, int centerY1, float width1, float height1){
    centerX = centerX1;
    centerY = centerY1;
    width = width1;
    height = height1;
  }
  void drawImg(){
      image(img, centerX-width/2, centerY-height/2, width, height); 
  }
  void drawImgOnPg(PGraphics pg){
      pg.image(img, centerX-width/2, centerY-height/2, width, height); 
  }
  
}