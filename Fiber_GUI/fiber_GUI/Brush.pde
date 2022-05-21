class Brush {
  int radius;
  color c;
  PGraphics pgImg;
  boolean isValid;

  Brush(int radius1, color c1, boolean isValid){
    radius = radius1;
    c = c1;
    isValid = false;
    pgImg = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);
    
  }

  void drawWithBrush(){
    
    if(!isValid) {
      image(pgImg, 100, 200); 
      return;
    }
    // print("draw with brush:"+isValid);
    pgImg.beginDraw();
    pgImg.noStroke();
    pgImg.fill(c);
    noStroke();
    pgImg.ellipse(mouseX-100,mouseY-200,radius,radius);
    pgImg.endDraw();
    image(pgImg, 100, 200); 

  }
}