/**
 * Brightness 
 * by Rusty Robison. 
 * 
 * Brightness is the relative lightness or darkness of a color.
 * Move the cursor vertically over each bar to alter its brightness. 
 */

Canvas canvas = new Canvas();

void setup() {

  pixelDensity(displayDensity());
  colorMode(RGB, 255, 255, 255);
  noStroke();
  background(255);
  size(700, 720);
  canvas.drawGUI();

}

void draw() {
  background(255);
  canvas.updateGUI();
}