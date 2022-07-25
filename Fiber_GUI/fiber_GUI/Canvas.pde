
Img img;
Img photo;
PGraphics paintLayer;
PGraphics picLayer;
PGraphics layersMerged;

Brush brush;
float brushSize;
float picRotation;
float picScale;
int imgX;
int imgY;
boolean isShowRealColor=false;


class Canvas{

  Fibers allFibers;
  Button addImgBtn;
  Button brushBtn;
  Button startBtn;
  Button deactivateBtn;
  // toggle button control the view (back or front)
  Button toggleFrontBack;
  Canvas(){
  }

  void drawGUI(){
    stroke(0);
    paintLayer = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);
    picLayer = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);
    layersMerged = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);
    PImage imgTmp= loadImage("images/hat2.png");
    float aspectRatio = ((float)imgTmp.height)/imgTmp.width;
    float aspectRatioSubWin = ((float)SUB_WIN_HEIGHT)/(float)SUB_WIN_WIDTH;

    if(aspectRatio > aspectRatioSubWin) {
      photo = new Img( imgTmp, PAINT_WIN_CENTER_X, PAINT_WIN_CENTER_Y, imgTmp.width * SUB_WIN_HEIGHT/ imgTmp.height,SUB_WIN_HEIGHT);
    }
    else {
      photo = new Img( imgTmp, PAINT_WIN_CENTER_X, PAINT_WIN_CENTER_Y, SUB_WIN_WIDTH, imgTmp.height * SUB_WIN_WIDTH/imgTmp.width);
    }
    textSize(50);
    fill(0, 0, 0);
    text("ChromoFiber Design Tool", 100, 70 );
    textSize(SLIDER_TEXT_SIZE);
    text("Brush Size", BRUSH_SLIDRE_X, BRUSH_SLIDRE_Y - SLIDER_TEXT_PADDING );
    text("Image Roatation", PICROTATION_SLIDER_X, PICROTATION_SLIDER_Y - SLIDER_TEXT_PADDING );
    text("Image Scale", PICSCALE_SLIDER_X, PICSCALE_SLIDER_Y - SLIDER_TEXT_PADDING );
    text("Image X", IMGX_SLIDER_X, IMGX_SLIDER_Y - SLIDER_TEXT_PADDING );
    text("Image Y", IMGY_SLIDER_X, IMGY_SLIDER_Y - SLIDER_TEXT_PADDING );
    allFibers = createHatFibers();
    brushBtn = new Button(1250,50,180,40,color(255,0,0),color(200,50,0),"Brush Off",0);
    addImgBtn = new Button(1250,100,180,40,color(255,0,0),color(200,50,0),"Add an Image",1);
    startBtn = new Button(1250,150,180,40,color(255,0,0),color(200,50,0),"Start Color Changing",2);
    deactivateBtn =  new Button(1250,650,180,40,color(255,0,0),color(200,50,0),"Deacviate",3);
    // tint(255, 128);
    brush = new Brush(20,INIT_BURSH_COLOR,true);
  }

  void updateGUI(){
    // String val = myPort.readStringUntil('*');
    // if(val !=null ){
    //     println("READ"+val+'\n');
    // }

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
    rect(PAINT_WIN_LEFT_TOP_X,PAINT_WIN_LEFT_TOP_Y, SUB_WIN_WIDTH, SUB_WIN_HEIGHT,10);
    rect(FIBER_WIN_LEFT_TOP_X,FIBER_WIN_LEFT_TOP_Y, SUB_WIN_WIDTH, SUB_WIN_HEIGHT,10);

    if(photo != null)photo.drawImg();
    if(img != null)img.drawImgOnPg(picLayer);

    brush.showBrushResult();
    paintLayer.endDraw();
    picLayer.endDraw();
    layersMerged.image(picLayer,0,0);
    layersMerged.image(paintLayer,0,0);
    layersMerged.endDraw();
    // ellipse(mouseX,mouseY,20,20);
    allFibers.updateFibers(FIBER_WIN_LEFT_TOP_X, FIBER_WIN_LEFT_TOP_Y, SUB_WIN_WIDTH, SUB_WIN_HEIGHT);
    allFibers.drawFibers(FIBER_WIN_LEFT_TOP_X, FIBER_WIN_LEFT_TOP_Y, SUB_WIN_WIDTH, SUB_WIN_HEIGHT);
    
    image(layersMerged,PAINT_WIN_LEFT_TOP_X, PAINT_WIN_LEFT_TOP_Y);
    addImgBtn.drawButton();
    brushBtn.drawButton();
    startBtn.drawButton();
    deactivateBtn.drawButton();
    brush.radius = (int)brushSize;
 
    if(img != null) {
      img.rotateAngle = picRotation;
      img.height =(int)( picScale/img.width * img.height);
      img.width =(int) picScale;
      img.centerX = imgX;
      img.centerY = imgY;
    }

    color cnew = color(cw.r(), cw.g(), cw.b());
    brush.c = cnew;
    
  }
}