

class Pixel{
  float x;
  float y;
  color c;
  
  Pixel(float x1, float y1, float r, float g, float b) {
    x = x1;
    y = y1;
    c =  color(r,g,b);
  }
  
}

class Fiber {
  ArrayList<Pixel> leds;

  Fiber(ArrayList<Pixel> inputLeds) {
    leds = inputLeds;
  }
  
  void drawFiber(float topLeftX, float topLeftY, float canvasWidth, float canvasHeight,float cameraImgWidth, float cameraImgHeight,int drawSetting) {
    
    Pixel pixel0 = leds.get(0);
    float prevWorldX = map(pixel0.x,0,cameraImgWidth,0,canvasWidth) + topLeftX;
    float prevWorldY = map(pixel0.y,0,cameraImgHeight,0,canvasHeight) + topLeftY;
    stroke(220,220,220);
    if(drawSetting == 2)noStroke();
    else strokeWeight(1); 
    fill(pixel0.c);
    rect(prevWorldX,prevWorldY,PIXEL_WIDTH,PIXEL_HEIGHT); 
    
    
    for (int i = 1; i < leds.size(); i++) {
      
      Pixel pixel = leds.get(i);
      float worldX = map(pixel.x,0,cameraImgWidth,0,canvasWidth) + topLeftX;
      float worldY = map(pixel.y,0,cameraImgHeight,0,canvasHeight) + topLeftY;
  
      fill(pixel.c);
      rect(worldX,worldY,PIXEL_WIDTH,PIXEL_HEIGHT); 
      if(drawSetting == 1){
        line(prevWorldX + PIXEL_WIDTH ,worldY,worldX,worldY);
        line(prevWorldX + PIXEL_WIDTH ,worldY + PIXEL_HEIGHT,worldX,worldY + PIXEL_HEIGHT);
      }
      
      prevWorldX = worldX;
      prevWorldY = worldY;
    }
    
  }
  void updatePixelColor(float topLeftX, float topLeftY, float canvasWidth, float canvasHeight,float cameraImgWidth, float cameraImgHeight) {
    // get color from canvas which is on the left side
    loadPixels();
    
    for (int i = 0; i < leds.size(); i++) {
      Pixel pixel = leds.get(i);
      float worldX = map(pixel.x,0,cameraImgWidth,0,canvasWidth) + topLeftX;
      float worldY = map(pixel.y,0,cameraImgHeight,0,canvasHeight) + topLeftY;
      // pixel.c = img.img.get((int)(worldX-img.centerX+img.width/2-SUB_WIN_SPACING),(int)( worldY-img.centerY+img.height/2));
      int referX = (int)(worldX - SUB_WIN_SPACING);
      int referY = (int)(worldY);
      pixel.c = pixels[referY * WINDOW_WIDTH + referX];
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
  
  void drawFibers(float topLeftX, float topLeftY, float canvasWidth, float canvasHeight ) {
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
}


Fibers createDefaultFibers() {
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