class Button{

  float centerX;
  float centerY;
  float width;
  float height;
  color pressColor;
  color noPressColor;
  boolean isPressed;
  String text;

  Button(float centerX1, float centerY1, float width1, float height1, color pressColor1, color noPressColor1, String text1){
    centerX = centerX1;
    centerY = centerY1;
    width = width1;
    height = height1;
    pressColor = pressColor1;
    noPressColor = noPressColor1;
    isPressed = false;
    text = text1;
  }

  void drawButton(){
    // stroke(255);
    if(mouseX> centerX - width/2 && mouseX< centerX + width/2 && mouseY > centerY - height/2 && mouseY<centerY+height/2 && mousePressed){
      fill(pressColor);
      // selectInput("Select a file to process:", "fileSelected");
      // img = new Img( loadImage(fileSelected),WINDOW_WIDTH/4,WINDOW_HEIGHT/4 );
    }
    else {
      fill(noPressColor);
    }
    rect(centerX-width/2, centerY-height/2, width, height,10);
    textSize(TEXT_SIZE);
    textAlign(CENTER,CENTER);
    fill(255);
    text(text, centerX,centerY);
  }

}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    // return selection.getAbsolutePath();
  }
  
}