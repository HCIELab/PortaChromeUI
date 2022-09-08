
Img img;
Img photo;
// users draw with brush on paintLayer
PGraphics paintLayer;
// users add image on piclayer
PGraphics picLayer;
PGraphics layersMerged;
// cover the merged layer to prevent the brush and image shows up
PGraphics coverMergeLayer;

Brush brush;
float brushSize = 20;
float picRotation;
float picScale;
int imgX;
int imgY;
boolean isShowRealColor=false;
boolean hasFiber = false;

class Canvas{

  Fibers allFibers;
//   Button addImgBtn;
  Button brushBtn;
  Button startBtn;
  Button deactivateBtn;
  Button importBtn;
  String bgImgPath="";
  // toggle button control the view (back or front)
  Button toggleFrontBack;
  Canvas(){
  }

  void drawGUI(){
    stroke(0);
    paintLayer = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);
    picLayer = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);

    layersMerged = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);
    if(bgImgPath!=""){
        // PImage imgTmp= loadImage(bgImgPath);
        // float aspectRatio = ((float)imgTmp.height)/imgTmp.width;
        // float aspectRatioSubWin = ((float)SUB_WIN_HEIGHT)/(float)SUB_WIN_WIDTH;
        // photo = new Img( imgTmp, PAINT_WIN_CENTER_X, PAINT_WIN_CENTER_Y, SUB_WIN_WIDTH, imgTmp.height * SUB_WIN_WIDTH/imgTmp.width);
    }
    
    
    
    textSize(40);
    fill(0, 0, 0);
    text("ChromoFiber Design Tool", 50, 70 );
    textSize(SLIDER_TEXT_SIZE);
    // text("Brush Size", BRUSH_SLIDRE_X, BRUSH_SLIDRE_Y - SLIDER_TEXT_PADDING );
    // text("Image Roatation", PICROTATION_SLIDER_X, PICROTATION_SLIDER_Y - SLIDER_TEXT_PADDING );
    // text("Image Scale", PICSCALE_SLIDER_X, PICSCALE_SLIDER_Y - SLIDER_TEXT_PADDING );
    // text("Image X", IMGX_SLIDER_X, IMGX_SLIDER_Y - SLIDER_TEXT_PADDING );
    // text("Image Y", IMGY_SLIDER_X, IMGY_SLIDER_Y - SLIDER_TEXT_PADDING );
    allFibers = createHatFibers();
    importBtn =  new Button(150,430,200,40,color(255,0,0),color(200,50,0),"Load LED positions",4);
    brushBtn = new Button(150,480,200,40,color(255,0,0),color(200,50,0),"Brush Off",0);
    // addImgBtn = new Button(400,480,200,40,color(255,0,0),color(200,50,0),"Add an Image",1);
    deactivateBtn =  new Button(150,530,200,40,color(255,0,0),color(200,50,0),"Perview",3);
    startBtn = new Button(150,580,200,40,color(255,0,0),color(200,50,0),"Start Color Changing",2);
    
    
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
    layersMerged.background(255);
    image(paintLayer, PAINT_WIN_LEFT_TOP_X, PAINT_WIN_LEFT_TOP_Y);
    stroke(0);
    noFill();
    rect(PAINT_WIN_LEFT_TOP_X-5,PAINT_WIN_LEFT_TOP_Y-5, SUB_WIN_WIDTH+10, SUB_WIN_HEIGHT+10,10);
    rect(FIBER_WIN_LEFT_TOP_X-5,FIBER_WIN_LEFT_TOP_Y-5, SUB_WIN_WIDTH+10, SUB_WIN_HEIGHT+10,10);

    if(photo != null)photo.drawImg();
    if(img != null)img.drawImgOnPg(picLayer);

    brush.showBrushResult();
    paintLayer.endDraw();
    picLayer.endDraw();
    layersMerged.image(picLayer,0,0);
    layersMerged.image(paintLayer,0,0);
    layersMerged.endDraw();
    image(layersMerged,PAINT_WIN_LEFT_TOP_X, PAINT_WIN_LEFT_TOP_Y);
    if(photo != null)photo.drawImg();
    if(hasFiber){
        allFibers.updateFibers(FIBER_WIN_LEFT_TOP_X, FIBER_WIN_LEFT_TOP_Y, SUB_WIN_WIDTH, SUB_WIN_HEIGHT);
        allFibers.drawFibers(FIBER_WIN_LEFT_TOP_X, FIBER_WIN_LEFT_TOP_Y, SUB_WIN_WIDTH, SUB_WIN_HEIGHT);
    }
    

    // addImgBtn.drawButton();
    brushBtn.drawButton();
    startBtn.drawButton();
    deactivateBtn.drawButton();
    importBtn.drawButton();
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