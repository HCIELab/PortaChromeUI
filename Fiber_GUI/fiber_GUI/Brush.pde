class Brush {
  int radius;
  color c;
  PGraphics pgImg;
  boolean isValid;
  PGraphics cursorLayer;

  Brush(int radius1, color c1, boolean isValid){
    radius = radius1;
    c = c1;
    isValid = false;
    pgImg = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);
    cursorLayer = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);
  }

  void showBrushResult(){
    // cursorLayer.beginDraw();
    // cursorLayer.clear();
    // cursorLayer.stroke(0);
    // cursorLayer.fill(c);
    // cursorLayer.ellipse(mouseX-100,mouseY-200,radius,radius);
    // // cursorLayer.tint(255,50)
    // cursorLayer.endDraw();
    
    image(pgImg, 100, 200); 
    // image(cursorLayer, 100, 200); 

  }
  void drawWithBrush(){
    if(!isValid) {
      return;
    }
    pgImg.beginDraw();
    pgImg.noStroke();
    pgImg.fill(c);
    pgImg.ellipse(mouseX-100,mouseY-200,radius,radius);
    pgImg.endDraw();
  }
}