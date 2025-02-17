boolean firstTime= true;
class Pixel{
    float x;
    float y;
    color c;
    // deativation time for each led
    int rTime;
    int gTime;
    int bTime;
    
    Pixel(float x1, float y1, float r, float g, float b) {
        x = x1;
        y = y1;
        c = color(r,g,b);
        rTime = 0;
        gTime = 0;
        bTime = 0;
    }

    
    // without hexagon rotation
    // void drawHexagon(float rotationAngle, float hexRadius, float centerX, float centerY) {
    //     // Set the fill and stroke color of the hexagon
    //     fill(c);   // Green fill color
    //     stroke(0);
        
    //     float sideLength = hexRadius/1.732*2;
    //     // Calculate the coordinates of the vertices of the hexagon
    //     float[] verticesX = new float[6];
    //     float[] verticesY = new float[6];
        
    //     for (int i = 0; i < 6; i++) {
    //         float angle = rotationAngle + TWO_PI * i / 6;
    //         verticesX[i] = centerX + cos(angle) * sideLength;
    //         verticesY[i] = centerY + sin(angle) * sideLength;
    //     }
        
    //     // Draw the hexagon
    //     beginShape();
    //     for (int i = 0; i < 6; i++) {
    //         vertex(verticesX[i], verticesY[i]);
    //     }
    //     endShape(CLOSE);
    // }

    // with 30 degree hexagon rotation
    void drawHexagon(float rotationAngle, float hexRadius, float centerX, float centerY) {
        // Set the fill and stroke color of the hexagon
        fill(c);   // Assuming 'c' is defined elsewhere in your code as the color
        stroke(0);
        
        float sideLength = hexRadius / 1.732 * 2;  // This is equivalent to hexRadius * sqrt(3)
        
        // Calculate the coordinates of the vertices of the hexagon
        float[] verticesX = new float[6];
        float[] verticesY = new float[6];
        
        for (int i = 0; i < 6; i++) {
            float angle = rotationAngle + TWO_PI * i / 6 + PI/6;  // Added PI/6 for 30-degree rotation
            verticesX[i] = centerX + cos(angle) * sideLength;
            verticesY[i] = centerY + sin(angle) * sideLength;
        }
        
        // Draw the hexagon
        beginShape();
        for (int i = 0; i < 6; i++) {
            vertex(verticesX[i], verticesY[i]);
        }
        endShape(CLOSE);
    }


}

class Fiber {
    
    // store the color from window on the left.
    ArrayList<Pixel> leds;
    //store the real color calculated by solver.py
    ArrayList<Pixel> ledsRealColor;
    

    Fiber(ArrayList<Pixel> inputLeds) {
        ledsRealColor = new ArrayList<Pixel>();
        leds= inputLeds;

        for(int i=0;i<inputLeds.size();i++){
            ledsRealColor.add(new Pixel(inputLeds.get(i).x,inputLeds.get(i).y,0.0,0.0,0.0));
        }
    }
    
    // convert the xy in coordinate of fibers[1920, 1080] to the world coordinates
    // if we need to draw the line between each led to make them look like a fiber(drawsetting =1 )
    void drawFiber(float topLeftX, float topLeftY, float canvasWidth, float canvasHeight,float cameraImgWidth, float cameraImgHeight,int drawSetting) {
         ArrayList<Pixel> ledsDrawn = ledsRealColor;
    
        if(isShowRealColor){
            // if now we need to draw the real color
            ledsDrawn = ledsRealColor;
        }else{
            ledsDrawn = leds;
        }
        Pixel pixel0 = ledsDrawn.get(0);

        float prevWorldX = map(pixel0.x,0,cameraImgWidth,0,canvasWidth) + topLeftX;
        float prevWorldY =  map(pixel0.y,0,cameraImgHeight,0,canvasHeight) + topLeftY;

        color prevColor = pixel0.c;
        stroke(220,220,220);
        if (drawSetting == 2)noStroke();
        else strokeWeight(1); 
        fill(pixel0.c);
        // rect(prevWorldX,prevWorldY,PIXEL_WIDTH,PIXEL_HEIGHT); 
        // if(firstTime) println("first ledPos:"+prevWorldX+","+prevWorldY);

        for (int i = 0; i < ledsDrawn.size(); i++) {
            
            Pixel pixel = ledsDrawn.get(i);
            float worldX = map(pixel.x,0,cameraImgWidth,0,canvasWidth) + topLeftX;
            float worldY = map(pixel.y,0,cameraImgHeight,0,canvasHeight) + topLeftY;
            float worldRadius = map(HEX_RADIUS,0,cameraImgWidth,0,canvasWidth);
      
            pixel.drawHexagon(rotateHexagon, worldRadius, worldX, worldY);

            // if(firstTime){
            //     println("ledPos:"+worldX+","+worldY);
            // }
            // fill(pixel.c);
            // // rect(worldX,worldY,PIXEL_WIDTH,PIXEL_HEIGHT); 
            // int segNum =int(dist(prevWorldX,prevWorldY,worldX,worldY)/PIXEL_WIDTH);
            // float angle1 = atan((worldY- prevWorldY)/(worldX-prevWorldX));
            
            // for(int j=0;j<segNum;j++){
            //     float inter = map(j, 0, segNum, 0, 1);
            //     color c = lerpColor(prevColor,pixel.c, inter);
            //     float segX = prevWorldX + (worldX-prevWorldX)/segNum*j;
            //     float segY = prevWorldY +  (worldY-prevWorldY)/segNum*j;
            //     segment(segX, segY,c,angle1);
                
            // }

            
            prevWorldX = worldX;
            prevWorldY = worldY;
            prevColor = pixel.c;

        }
        firstTime = false;
        
    }


    void segment(float x, float y, color c, float angle) {
        pushMatrix();
        translate(x,y);
        fill(c);
        rotate(angle);
        rect(0,0, PIXEL_WIDTH, PIXEL_HEIGHT);
        popMatrix();
    }

 
    void updatePixelColor(float topLeftX, float topLeftY, float canvasWidth, float canvasHeight,float cameraImgWidth, float cameraImgHeight) {
        // get color from canvas which is on the left side
        layersMerged.loadPixels();
        for (int i = 0; i < leds.size(); i++) {
            Pixel pixel = leds.get(i);
            float worldX = map(pixel.x,0,cameraImgWidth,0,canvasWidth) + topLeftX;
            float worldY = map(pixel.y,0,cameraImgHeight,0,canvasHeight) + topLeftY;
           // pixel.c = img.img.get((int)(worldX-img.centerX+img.width/2-SUB_WIN_SPACING),(int)( worldY-img.centerY+img.height/2));
            int referX = (int)(worldX - FIBER_WIN_LEFT_TOP_X);
            int referY = (int)(worldY) - FIBER_WIN_LEFT_TOP_Y;

            pixel.c = layersMerged.pixels[referY * SUB_WIN_WIDTH + referX];
        }
}
    
}

class Fibers {
    ArrayList<Fiber> fibers;
    int fiberNum;
    float cameraImgWidth;
    float cameraImgHeight;
    int drawSetting;// 1:draw fiber 2: only led
    Fibers(ArrayList<Fiber> fibers1, float cameraImgWidth1, float cameraImgHeight1) {
        fiberNum = fibers1.size();
        fibers = fibers1;
        cameraImgWidth = cameraImgWidth1;
        cameraImgHeight = cameraImgHeight1;
        drawSetting = 2;
}
    
    void drawFibers(float topLeftX, float topLeftY, float canvasWidth, float canvasHeight) {
        for (int i = 0; i < fiberNum;i++) {
            Fiber targetFiber = fibers.get(i);
            targetFiber.drawFiber(topLeftX,  topLeftY,  canvasWidth,  canvasHeight, cameraImgWidth,  cameraImgHeight,  drawSetting);
        }
}
    
    void updateFibers(float topLeftX, float topLeftY, float canvasWidth, float canvasHeight) {
        for (int i = 0; i < fiberNum;i++) {
            Fiber targetFiber = fibers.get(i);
            
            targetFiber.updatePixelColor(topLeftX,  topLeftY,  canvasWidth,  canvasHeight, cameraImgWidth,  cameraImgHeight);
        }
}
    void updateRealColor(ArrayList<ColorTmp> realColors){
        int realColorIdx=0;
        for (int i = 0; i < fiberNum;i++) {
            Fiber targetFiber = fibers.get(i);
            for(int j=0;j<targetFiber.leds.size();j++){
                color newColor = color(realColors.get(realColorIdx).r, realColors.get(realColorIdx).g, realColors.get(realColorIdx).b);
                targetFiber.ledsRealColor.get(j).c = newColor;
                targetFiber.ledsRealColor.get(j).rTime = realColors.get(realColorIdx).rTime;
                targetFiber.ledsRealColor.get(j).gTime = realColors.get(realColorIdx).gTime;
                targetFiber.ledsRealColor.get(j).bTime = realColors.get(realColorIdx).bTime;
                realColorIdx++;
            }
        }
    }

}

 // process every line in the ledpos file, and output the fibers
Fibers readFibersFromFile(){
    ArrayList<Fiber> fiberList =  new ArrayList<Fiber>();
    String[] lines = loadStrings("ledPos.txt"); // for 108 leds, change file to ledPos108.txt and float rotateHexagon = 3.1415926/6; (in fiber_GUI.pde), float HEX_RADIUS = 45.0f; in const.pde
    // String[] lines = 

    // String[] lines = new String[FIBER_NUMBER];
    // String ledPos = create72LedPos();
    // lines[0] = ledPos;
    
    int fiberNum = lines.length;

    //  create a fiber with each line
    for (int i = 0; i < fiberNum; i++) {
        ArrayList<Pixel> pixelList =  new ArrayList<Pixel>();

        // spilt the positions with ';'
        String[] pos = split(lines[i], ';');
        for(int j = 0; j<pos.length-1; j++) {
            // spilt the position with ','
            String[] posi = split(pos[j], ',');
            // get the x and y position of each led
            if(posi.length<2) continue;
            float x = parseFloat(posi[0]);
            float y = parseFloat(posi[1]);

            // create a new pixel with the x and y position
            Pixel p = new Pixel(x,y, 255.0f,0.0f,255.0f);
            // add the pixel to the fiber
            pixelList.add(p);
        }
        // create a new fiber with the pixel list
        fiberList.add(new Fiber(pixelList));
    }
    canvas.allFibers = new Fibers(fiberList,1920, 1080);
    return new Fibers(fiberList,1920, 1080);
}


String transform(String string, float horizontal_gap, float vertical_gap) {
  String[] pairs = split(string, ';');
  String result = "";

  for (int i = 0; i < pairs.length; i++) {
    String[] numbers = split(pairs[i], ',');
    if (numbers[0].equals("")) continue;
    numbers[0] = str(int(numbers[0]) + horizontal_gap);
    numbers[1] = str(int(numbers[1]) + vertical_gap);
    result += join(numbers, ",") + ";";
  }

  return result;
}

String createLedPos(){
    String topLeft = "";

    for (int i = 0; i < HORIZONTAL_NUM; i++) {
        for (int j = 0; j < VERTICAL_NUM; j++) {
        float x = i * HEX_RADIUS * 2 + SHIFT_X;
        float y;
        if (i % 2 == 0) {
            // from bottom to up
            y = j * HEX_RADIUS * 2 + SHIFT_Y;
        } else {
            // from up to bottom
            y = (2 * VERTICAL_NUM - 1) * HEX_RADIUS - j * HEX_RADIUS * 2 + SHIFT_Y;
        }
        topLeft += str(x) + "," + str(y) + ";";
        }
    }

    String topRight = transform(topLeft, HORIZONTAL_GPA + 6 * 2 * HEX_RADIUS, 0);
    String bottomLeft = transform(topLeft, 0, VERTICAL_GPA + 6 * 2 * HEX_RADIUS);
    String bottomRight = transform(topLeft, HORIZONTAL_GPA + 6 * 2 * HEX_RADIUS, VERTICAL_GPA + 6 * 2 * HEX_RADIUS);

    String ledPos = topLeft + topRight + ";" + bottomLeft + ";" + bottomRight;
    return ledPos;
}

String create72LedPos(){
    int SHIFT_X_1 = 960;
    int SHIFT_Y_1 = 300;
    // int HEX_RADIUS = 50;
    // int HORIZONTAL_NUM = 6;
    // int VERTICAL_NUM = 6;
    String ans = "";
    float y=0;
    for (int i = 0; i < HORIZONTAL_NUM; i++) {
        y = i * HEX_RADIUS * 2 + SHIFT_Y_1;

        for (int j = 0; j < VERTICAL_NUM; j++) {
        float x;
        if (i % 2 == 0) {
            x = SHIFT_X_1 - HEX_RADIUS - 2 * HEX_RADIUS * j;
        } else {
            x = SHIFT_X_1 - 12 * HEX_RADIUS + 2 * HEX_RADIUS * j;
        }
        ans += str(x) + "," + str(y) + ";";
        }
    }
    print(y);
    for(int i = 0; i<HORIZONTAL_NUM; i++){
        float y1 = y -i * HEX_RADIUS * 2;
        for (int j = 0; j < VERTICAL_NUM; j++) {
            float x;
            if (i % 2 == 0) {
                x = SHIFT_X_1  + 2 * HEX_RADIUS * j;
            } else {
                x = SHIFT_X_1 +HEX_RADIUS+ 10 * HEX_RADIUS - 2 * HEX_RADIUS * j;
            }
            ans += str(x) + "," + str(y1) + ";";
        }
    }
    print(ans);
    return ans;
}