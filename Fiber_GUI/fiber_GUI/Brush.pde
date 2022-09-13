// By Yixiao Kang(kyx999@sjtu.edu.cn)
// define the Brush class which is used to draw on the canvas

class Brush {
  int radius;
  color c;
  boolean isValid;
  PGraphics cursorLayer;
  Brush(int radius1, color c1, boolean isValid){
    radius = radius1;
    c = c1;
    isValid = false;
    cursorLayer = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);
  }

  void showBrushResult(){

    paintLayer.beginDraw();
    paintLayer.fill(c);
    paintLayer.endDraw();
    image(paintLayer, PAINT_WIN_LEFT_TOP_X, PAINT_WIN_LEFT_TOP_Y); 
  }

  void drawWithBrush(){
    if(!isValid) {
      return;
    }
    
    paintLayer.beginDraw();
    paintLayer.noStroke();
    paintLayer.fill(c);
    paintLayer.stroke(c);
    paintLayer.strokeWeight(radius);  // Thicker
    paintLayer.line(mouseX-PAINT_WIN_LEFT_TOP_X, mouseY- PAINT_WIN_LEFT_TOP_Y, pmouseX-PAINT_WIN_LEFT_TOP_X, pmouseY- PAINT_WIN_LEFT_TOP_Y);
    paintLayer.endDraw();
  }
}