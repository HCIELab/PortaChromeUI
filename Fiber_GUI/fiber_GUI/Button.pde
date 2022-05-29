class Button{
  
  float centerX;
  float centerY;
  float width;
  float height;
  color pressColor;
  color noPressColor;
  color currColor;
  boolean isPressed;
  String text;
  // type0: brush button; 
  // type1: choose image button; 
  // type2: start color changing button;
  int type; 
  
  Button(float centerX1, float centerY1, float width1, float height1, color pressColor1, color noPressColor1, String text1, int type1) {
    centerX = centerX1;
    centerY = centerY1;
    width = width1;
    height = height1;
    pressColor = pressColor1;
    noPressColor = noPressColor1;
    isPressed = false;
    text = text1;
    type = type1;
    currColor = (isPressed)? pressColor : noPressColor;
  }
  
  void drawButton() {
    // stroke(255);
    // if (mouseX > centerX - width / 2 && mouseX < centerX + width / 2 && mouseY > centerY - height / 2 && mouseY < centerY + height / 2 && mousePressed) {
    //   fill(pressColor);
    //   // buttonFunc();
    //   // selectInput("Select a file to process:", "fileSelected");
    //   // img = new Img( loadImage(fileSelected),WINDOW_WIDTH/4,WINDOW_HEIGHT/4 );
    // }
    // else {
    //   fill(noPressColor);
    // }
    fill(currColor);
    rect(centerX - width / 2, centerY - height / 2, width, height,10);
    textSize(TEXT_SIZE);
    textAlign(CENTER,CENTER);
    fill(255);
    text(text, centerX,centerY);
  }
  
  void checkBtnClicked() {
    if (mouseX > centerX - width / 2 && mouseX < centerX + width / 2 && mouseY > centerY - height / 2 && mouseY < centerY + height / 2) {
      isPressed = !isPressed;
      switch(type) {
        case 0 : {
           // brush button; 
            brush.isValid = !brush.isValid;
            if(isPressed) {
              text = "Brush On";
              currColor = pressColor;
            }else{
               text = "Brush Off";
               currColor = noPressColor;
            }
            // print("brush is valid:" + brush.isValid + '\n');
            break;
          }
          case 1 : {
            PImage imgTmp= loadImage("images/flower.jpeg");
            float scale = INIT_PIC_WIDTH/imgTmp.width;

            img = new Img( imgTmp,400,500, (int)(imgTmp.width*scale),(int)(imgTmp.height*scale));
            // print("case1");
            break;
        }
      }
    }
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