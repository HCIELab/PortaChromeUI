

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
    //type0: brush button; 
    //type1: choose image button; 
    //type2: start color changing button;
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
        currColor = (isPressed) ? pressColor : noPressColor;
    }
    
    void drawButton() {
        fill(currColor);
        rect(centerX - width / 2, centerY - height / 2, width, height,10);
        textSize(BTN_TEXT_SIZE);
        textAlign(CENTER,CENTER);
        fill(255);
        text(text, centerX,centerY);
    }
    
    // checkwhich button is clicked and respond accordingly
    // type0: brush button; 
    // type1: choose image button; 
    // type2: start color changing button;
    void checkBtnClicked() {
        if (mouseX > centerX - width / 2 && mouseX < centerX + width / 2 && mouseY > centerY - height / 2 && mouseY < centerY + height / 2) {
            isPressed = !isPressed;
            switch(type) {
                case 0 : {
                        // brushbutton; 
                        brush.isValid = !brush.isValid;
                        if (isPressed) {
                            text = "Brush On";
                            currColor = pressColor;
                        } else{
                            text = "BrushOff";
                            currColor = noPressColor;
                            }
                        // print("brush is valid:" + brush.isValid + '\n');
                        break;
                        }
                    case 1 : {
                        selectInput("Choose an image","imageSelected");
                        
                        // print("case1");
                        break;
                    }
                    case 2 : {
                        print("start color changeing ");
                        // // write led data to myPort
                        Fiber targetFiber = canvas.allFibers.fibers.get(0);
                        String code ="";
                        for (int i = 0; i <targetFiber.leds.size() ; i++) {
                            Pixel p = targetFiber.leds.get(i);
                            // the acutual rgb of color is grb
                            code += str(int(red(p.c)))+","+str(int(green(p.c)))+","+str(int(blue(p.c)))+"#";
                        }
                        code +="*";
                        myPort.write(code);
                        print(code+'\n');
                        // myPort.write("255,0,0#0,255,0#0,0,255#*");    
                        break;
                    }
                }
            }
        }
    
    }

void imageSelected(File selection) {
    if (selection ==  null) {println("Error");}
    else{
        PImage imgTmp = loadImage(selection.getAbsolutePath());
        float scale = INIT_PIC_WIDTH / imgTmp.width;
        
        img = new Img(imgTmp,PAINT_WIN_LEFT_TOP_X + SUB_WIN_WIDTH / 2,PAINT_WIN_LEFT_TOP_Y + SUB_WIN_HEIGHT / 2,(int)(imgTmp.width * scale),(int)(imgTmp.height * scale));
        startImageProcessing();
        }
    }

void startImageProcessing() {
    // now the picture is loaded 
    // we can now dosome stuff with the picture
    }