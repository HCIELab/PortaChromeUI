/**
 * Brightness 
 * by Rusty Robison. 
 * 
 * Brightness is the relative lightness or darkness of a color.
 * Move the cursor vertically over each bar to alter its brightness. 
 */
 


void setup() {
  size(640, 360);
  colorMode(RGB, 255, 255, 255);
  noStroke();
  background(0);
  Fibers fibers = createDefaultFibers();
  fibers.drawFibers(0.0f,0.0f,300.0f,300.0f);
}

void draw() {

}