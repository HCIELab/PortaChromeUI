

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
    // type 0: brush on/off; 
    // type 1: choose image; 
    // type 2: start color changing;
    // type 3: show color after deactivation; 
    // type 4: import package from calibration tool;
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
        stroke(0);
        rect(centerX - width / 2, centerY - height / 2, width, height,10);
        textSize(BTN_TEXT_SIZE);
        textAlign(CENTER,CENTER);
        fill(255);
        text(text, centerX,centerY);
    }
    
    // checkwhich button is clicked and respond accordingly
    // type 0: brush on/off; 
    // type 1: choose image; 
    // type 2: Send Color Pattern;
    // type 3: show color after deactivation; 
    // type 4: import package from calibration tool;
    void checkBtnClicked() {
        if (mouseX > centerX - width / 2 && mouseX < centerX + width / 2 && mouseY > centerY - height / 2 && mouseY < centerY + height / 2) {
            isPressed = !isPressed;
            switch(type) {
                case 0 : {
                        // brushbutton; 
                        brush.isValid = !brush.isValid;
                        if (isPressed) {
                            text = "Turn off Brush";
                            currColor = pressColor;
                        } else{
                            text = "Turn off Brush";
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

                        print("start color changing \n ");
                        // // write led data to myPort
                        String code = "d#";
                        int ledIndex = 0;
                        // write the display fiber color to the serial port
                        for (int j = 0;j < canvas.allFibers.fibers.size();j++) {
                            Fiber targetFiber = canvas.allFibers.fibers.get(j);
                            
                            for (int i = 0; i < targetFiber.leds.size() && ledIndex < MAX_LED; i++) {
                                Pixel p = targetFiber.leds.get(i);
                                // the acutual rgb of color is grb
                                ledIndex += 1;
                                code += str(int(red(p.c))) + "," + str(int(green(p.c))) + "," + str(int(blue(p.c))) + "#";
                            }
                            
                        }

                        code += "*v";

                        // print(code+'\n');
                        ledIndex = 0;
                        // write the v：deactivation color to the serial port
                        for (int j = 0;j < canvas.allFibers.fibers.size();j++) {
                            Fiber targetFiber = canvas.allFibers.fibers.get(j);
                        
                            for (int i = 0; i < targetFiber.ledsRealColor.size() && ledIndex < MAX_LED; i++) {
                                Pixel p = targetFiber.ledsRealColor.get(i);
                                // the acutual rgb of color is grb
                                ledIndex += 1;
                          
                                code += str(int(red(p.c))) + "," + str(int(green(p.c))) + "," + str(int(blue(p.c))) + "#";
                            }
                            
                        }
                        code += "*";
                        print(code);
                        // myPort.write(code);
                        
                        // basic rgb test
                        // myPort.write("255,0,0#0,255,0#0,0,255#*");    
                        break;
                    }

                case 3 : {
                        if(isShowRealColor == false) {
                            // text = "Simulate";
                            // the text need to be passed is same as case 2, pass it to python to calculate the real color
                            print("start calculate real color");
                            String code = "";
                            int ledIndex = 0;
                            for (int j = 0;j < canvas.allFibers.fibers.size();j++) {
                                Fiber targetFiber = canvas.allFibers.fibers.get(j);
                                
                                for (int i = 0; i < targetFiber.leds.size() ; i++) {
                                    Pixel p = targetFiber.leds.get(i);
                                    // the acutual rgb of color is grb
                                    ledIndex += 1;
                                    code += str(int(red(p.c))) + "," + str(int(green(p.c))) + "," + str(int(blue(p.c))) + "#";
                                }
                                
                            }
                            code += "*";
                            print("processing sent "+ledIndex+" led to python");
                            output.println(code);
                            output.flush();
                            output.close();
                            // tell python solver.py to calculate
                            myClient.write("1");
                            isShowRealColor = true;
                            currColor = pressColor;
                        }
                        else{
                            // text = "Simulate";
                            print("show original color");
                            isShowRealColor = false;
                            currColor = noPressColor;
                        }

                        break;
                }
                case 4:{
                    selectInput("Choose an image","bgImageSelected");
                    // selectInput("Choose ledPosition files", "ledPosSelected");
                    readFibersFromFile();
                    hasFiber = true;
                    break;
                }
                case 5:{
                    println("case 5 color wheel mode or color picker mode");
                    hideColorWheel= !hideColorWheel;
                    currColor = noPressColor;
                    if(hideColorWheel){
                        text = "Color Picker Mode";
                    }
                    else{
                        text = "Color Wheel Mode";
                    }
                    
                    break;
                }
                case 6: {
                    println("case 6 check which color picker is clicked and update the color of the brush");
                    if(hideColorWheel){
                        println("Change to r:"+red(pressColor)+",g:"+green(pressColor)+",b:"+blue(pressColor));
                        brush.c = color(red(pressColor),green(pressColor),blue(pressColor));
                    }
                    
                    
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
        // startImageProcessing();
    }
}

void bgImageSelected(File selection) {
    if (selection ==  null) {println("Error");}
    else{
        canvas.bgImgPath = selection.getAbsolutePath();
        println("bg image path: " + canvas.bgImgPath);

        PImage imgTmp= loadImage(canvas.bgImgPath);
        float aspectRatio = ((float)imgTmp.height)/imgTmp.width;
        float aspectRatioSubWin = ((float)SUB_WIN_HEIGHT)/(float)SUB_WIN_WIDTH;
        photo = new Img( imgTmp, PAINT_WIN_CENTER_X, PAINT_WIN_CENTER_Y, SUB_WIN_WIDTH, imgTmp.height * SUB_WIN_WIDTH/imgTmp.width);

    }
}

// void ledPosSelected(File selection) {
//     if (selection ==  null) {println("Error");}
//     else{
//         canvas.ledPosPath = selection.getAbsolutePath();
//         println("led pos path: " + canvas.ledPosPath);
//         readFibersFromFile();
//     }
// }

// void startImageProcessing() {
//     // now the picture is loaded 
//     // we can now dosome stuff with the picture
// }
