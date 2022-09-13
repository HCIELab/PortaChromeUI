boolean firstTime= true;
class Pixel{
    float x;
    float y;
    color c;
    
    Pixel(float x1, float y1, float r, float g, float b) {
        x = x1;
        y = y1;
        c = color(r,g,b);
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

        for (int i = 1; i < ledsDrawn.size(); i++) {
            
            Pixel pixel = ledsDrawn.get(i);
            float worldX = map(pixel.x,0,cameraImgWidth,0,canvasWidth) + topLeftX;
            float worldY = map(pixel.y,0,cameraImgHeight,0,canvasHeight) + topLeftY;
            if(firstTime){
                println("ledPos:"+worldX+","+worldY);
            }
            fill(pixel.c);
            // rect(worldX,worldY,PIXEL_WIDTH,PIXEL_HEIGHT); 
            int segNum =int(dist(prevWorldX,prevWorldY,worldX,worldY)/PIXEL_WIDTH);
            float angle1 = atan((worldY- prevWorldY)/(worldX-prevWorldX));
            
            for(int j=0;j<segNum;j++){
                float inter = map(j, 0, segNum, 0, 1);
                color c = lerpColor(prevColor,pixel.c, inter);
                float segX = prevWorldX + (worldX-prevWorldX)/segNum*j;
                float segY = prevWorldY +  (worldY-prevWorldY)/segNum*j;
                segment(segX, segY,c,angle1);
                
            }

            
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
        loadPixels();
        
        for (int i = 0; i < leds.size(); i++) {
            Pixel pixel = leds.get(i);
            float worldX = map(pixel.x,0,cameraImgWidth,0,canvasWidth) + topLeftX;
            float worldY = map(pixel.y,0,cameraImgHeight,0,canvasHeight) + topLeftY;
            int referX = (int)(worldX - SUB_WIN_SPACING);
            int referY = (int)(worldY);
            pixel.c = pixels[referY * WINDOW_WIDTH + referX];
        }
    }
    void updatePixelColor2(float topLeftX, float topLeftY, float canvasWidth, float canvasHeight,float cameraImgWidth, float cameraImgHeight) {
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
            
            targetFiber.updatePixelColor2(topLeftX,  topLeftY,  canvasWidth,  canvasHeight, cameraImgWidth,  cameraImgHeight);
        }
}
    void updateRealColor(ArrayList<ColorTmp> realColors){
        int realColorIdx=0;
        for (int i = 0; i < fiberNum;i++) {
            Fiber targetFiber = fibers.get(i);
            for(int j=0;j<targetFiber.leds.size();j++){
                color newColor = color(realColors.get(realColorIdx).r, realColors.get(realColorIdx).g, realColors.get(realColorIdx).b);
                targetFiber.ledsRealColor.get(j).c = newColor;
                realColorIdx++;
            }
        }
    }

}


Fibers createDefaultFibers() {
    // all fibers makes up a rectangle
    int fiberNum = 60;
    int pixelsPerFiber = 60;
    float PIXEL_PADDING_X = 5.0f;
    float PIXEL_PADDING_Y = 5.0f;
    float cameraImgWidth1 = 0.0f;
    float cameraImgHeight1 = 0.0f; 
    
    ArrayList<Fiber> fiberList =  new ArrayList<Fiber>();
    for (int i = 0; i < fiberNum; ++i) {
        ArrayList<Pixel> pixelList =  new ArrayList<Pixel>();
        for (int j = 0; j < pixelsPerFiber;j++) {
           // color c = color(100,200,100);
            float x = (PIXEL_WIDTH + PIXEL_PADDING_X) * j;
            float y = (PIXEL_HEIGHT + PIXEL_PADDING_Y) * i;
            
            Pixel p = new Pixel(x,y, 255.0f,0.0f,255.0f);
            pixelList.add(p);
        }
        fiberList.add(new Fiber(pixelList));
        cameraImgWidth1 = pixelsPerFiber * PIXEL_WIDTH + (pixelsPerFiber - 1) * PIXEL_PADDING_X;
        cameraImgHeight1 = fiberNum * PIXEL_HEIGHT + (fiberNum - 1) * PIXEL_PADDING_Y;
}
    return new Fibers(fiberList,cameraImgWidth1,cameraImgHeight1);
}

Fibers createFibers2() {
    int fiberNum = 60;
    int pixelsPerFiber = 60;
    float PIXEL_PADDING_X = 5.0f;
    float PIXEL_PADDING_Y = 5.0f;
    float cameraImgWidth1 = (PIXEL_PADDING_X + PIXEL_WIDTH) * pixelsPerFiber;
    float cameraImgHeight1 = (PIXEL_PADDING_Y + PIXEL_HEIGHT) * fiberNum; 
    float deltaR = PIXEL_PADDING_X + PIXEL_WIDTH;
    float deltaTheta = 3.14 / 3 / fiberNum;
    ArrayList<Fiber> fiberList =  new ArrayList<Fiber>();
    for (int i = 0; i < fiberNum; ++i) {
        ArrayList<Pixel> pixelList =  new ArrayList<Pixel>();
        float thetai = deltaTheta * i;
        for (int j = 0; j < pixelsPerFiber;j++) {
           // color c = color(100,200,100);
            float rj = deltaR * j;
            float x = rj * cos(thetai);
            float y = rj * sin(thetai);
            
            Pixel p = new Pixel(x,y, 255.0f,0.0f,255.0f);
            pixelList.add(p);
        }
        fiberList.add(new Fiber(pixelList));
        
    }   
    return new Fibers(fiberList,cameraImgWidth1,cameraImgHeight1);
}

Fibers createHatFibers() {
    // create a sector so that the fibers to mimic a hat
    int fiberNum = 30;
    int pixelsPerFiber = 30;
    float PIXEL_PADDING_X = 5.0f;
    float PIXEL_PADDING_Y = 5.0f;
    
    float cameraImgHeight1 = (PIXEL_PADDING_Y + PIXEL_HEIGHT) * fiberNum;  
    float cameraImgWidth1 = cameraImgHeight1;
    float deltaR = PIXEL_PADDING_X + PIXEL_WIDTH;
    float deltaTheta = 3.14 / 3 / fiberNum;
    ArrayList<Fiber> fiberList =  new ArrayList<Fiber>();
    for (int i = 0; i < fiberNum; ++i) {
        ArrayList<Pixel> pixelList =  new ArrayList<Pixel>();
        float thetai = deltaTheta * i;
        for (int j = 0; j < pixelsPerFiber;j++) {
           // color c = color(100,200,100);
            float rj = deltaR * j;
            float x = cameraImgWidth1 / 2 - rj * cos(3.14 / 3 + thetai);
            float y = rj * sin(3.14 / 3 + thetai);
            Pixel p = new Pixel(x,y, 255.0f,0.0f,255.0f);
            pixelList.add(p);
        }
        fiberList.add(new Fiber(pixelList));
        
    }
    return new Fibers(fiberList,cameraImgWidth1,cameraImgHeight1);
}

 // process every line in the ledpos file, and output the fibers
Fibers readFibersFromFile(){
    ArrayList<Fiber> fiberList =  new ArrayList<Fiber>();
    String[] lines =loadStrings("ledPos.txt");
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
            int x = Integer.parseInt(posi[0]);
            int y = Integer.parseInt(posi[1]);
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