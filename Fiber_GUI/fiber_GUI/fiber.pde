
float PIXEL_WIDTH =20.0f;
float PIXEL_HEIGHT = 10.0f;



class Pixel{
  float x;
  float y;
  color c;

  Pixel(float x1, float y1, float r, float g, float b){
    x=x1;
    y=y1;
    c =  color(r,g,b);
  }
}

class Fiber {
  ArrayList<Pixel> pixels;

  Fiber(ArrayList<Pixel> inputPixels){
  
     pixels = inputPixels;
  }

  void drawFiber(float topLeftX, float topLeftY, float canvasWidth, float canvasHeight,float cameraImgWidth, float cameraImgHeight){
    for(int i=0; i<pixels.size(); i++){
      Pixel pixel = pixels.get(i);
      float worldX = map(pixel.x,0,cameraImgWidth,0,canvasWidth)+topLeftX;
      float worldY = map(pixel.y,0,cameraImgHeight,0,canvasHeight)+topLeftY;
      fill(pixel.c);
      rect(worldX,worldY,PIXEL_WIDTH,PIXEL_HEIGHT );
    }
    
  }

}

class Fibers {
  ArrayList<Fiber> fibers;
  int fiberNum;
  float cameraImgWidth;
  float cameraImgHeight;

  Fibers( ArrayList<Fiber> fibers1, float cameraImgWidth1, float cameraImgHeight1){
    fiberNum = fibers1.size();
    fibers = fibers1;
    cameraImgWidth = cameraImgWidth1;
    cameraImgHeight = cameraImgHeight1;
  }

  void drawFibers(float topLeftX, float topLeftY, float canvasWidth, float canvasHeight){
    for(int i = 0; i < fiberNum;i++){
      Fiber targetFiber = fibers.get(i);
      targetFiber.drawFiber( topLeftX,  topLeftY,  canvasWidth,  canvasHeight, cameraImgWidth,  cameraImgHeight);
    }
  }

  void testFunc(){
    print("call function");
  }

}


Fibers createDefaultFibers(){
  int fiberNum = 10;
  int pixelsPerFiber = 10;
  float PIXEL_PADDING_X = 5.0f;
  float PIXEL_PADDING_Y = 10.0f;
  float cameraImgWidth1 = 0.0f;
  float cameraImgHeight1 = 0.0f; 

  ArrayList<Fiber> fiberList =  new ArrayList<Fiber>();
  for (int i = 0; i < fiberNum; ++i) {
     ArrayList<Pixel> pixelList =  new ArrayList<Pixel>();
    for(int j = 0; j < pixelsPerFiber;j++){
      // color c = color(100,200,100);
      float x = (PIXEL_WIDTH + PIXEL_PADDING_X)*j;
      float y = (PIXEL_HEIGHT+ PIXEL_PADDING_Y)*i;
      cameraImgWidth1 = (x>cameraImgWidth1)? x:cameraImgWidth1;
      cameraImgHeight1 = (y>cameraImgHeight1)? y:cameraImgHeight1;
      Pixel p = new Pixel(x,y, 255.0f,255.0f,255.0f);
      pixelList.add(p);
    }
    fiberList.add(new Fiber(pixelList));
  }
  return new Fibers(fiberList,cameraImgWidth1,cameraImgHeight1);
}