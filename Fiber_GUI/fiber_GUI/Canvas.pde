Img img;
Img photo;
PGraphics paintLayer;
PGraphics picLayer;
PGraphics layersMerged;

Brush brush;

class Canvas{

  Fibers fibers;
  Button addImgBtn;
  Button brushBtn;
  Button startBtn;
  
  Canvas(){
    
  }



  void drawGUI(){
    stroke(0);
    paintLayer = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);
    picLayer = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);
    layersMerged = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);
    PImage imgTmp= loadImage("images/hat.jpg");
    float aspectRatio = ((float)imgTmp.height)/imgTmp.width;
    float aspectRatioSubWin = ((float)SUB_WIN_HEIGHT)/(float)SUB_WIN_WIDTH;


    if(aspectRatio > aspectRatioSubWin) {

      photo = new Img( imgTmp,400,500, imgTmp.width * SUB_WIN_HEIGHT/ imgTmp.height,SUB_WIN_HEIGHT);
    }
    else {
      photo = new Img( imgTmp,400,500, SUB_WIN_WIDTH, imgTmp.height * SUB_WIN_WIDTH/imgTmp.width);
    }
    textSize(50);
    fill(0, 0, 0);
    text("ChromoFiber Design Tool", 100, 70 ); 
    // img = new Img( imgTmp,400,500, imgTmp.width,imgTmp.height);
    fibers = createDefaultFibers();
    // fibers = createFibers2();
    brushBtn = new Button(900,50,200,50,color(255,0,0),color(200,50,0),"Brush Off",0);
    addImgBtn = new Button(1150,50,200,50,color(255,0,0),color(200,50,0),"Add an Image",1);
    startBtn = new Button(1400,50,200,50,color(255,0,0),color(200,50,0),"Start Color Changing",2);
    // tint(255, 128);
    brush = new Brush(20,INIT_BURSH_COLOR,true);
  }
  void updateGUI(){
    paintLayer.beginDraw();
    picLayer.beginDraw();
    layersMerged.beginDraw();

    paintLayer.noFill();
    picLayer.noFill();
    
    // clear last picLayer but keep last paintLayer
    picLayer.clear();
    layersMerged.clear();
    image(paintLayer, PAINT_WIN_LEFT_TOP_X, PAINT_WIN_LEFT_TOP_Y);
    stroke(0);
    noFill();
    rect(100,200,600,600,10);
  
    if(photo != null)photo.drawImg();
    if(img != null)img.drawImgOnPg(picLayer);

    brush.showBrushResult();
    paintLayer.endDraw();
    picLayer.endDraw();
    layersMerged.image(picLayer,0,0);
    layersMerged.image(paintLayer,0,0);
    layersMerged.endDraw();
    // ellipse(mouseX,mouseY,20,20);
    fibers.updateFibers(900.0f,200.0f,600.0f,600.0f);
    fibers.drawFibers(900.0f,200.0f,600.0f,600.0f);
    
    image(layersMerged,100,200);
    addImgBtn.drawButton();
    brushBtn.drawButton();
    startBtn.drawButton();
    
  }



 

}