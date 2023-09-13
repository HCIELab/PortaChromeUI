// By Yixiao Kang(kyx999@sjtu.edu.cn)
// define the Canvas class, control all the widgets in the canvas.


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

class Canvas{
  Fibers allFibers;
  Button addImgBtn;
  Button brushBtn;
  Button startBtn;
  Button deactivateBtn;
  Button importBtn;
  Button colorModeBtn;
  Button colorPickerCyanBtn;
  Button colorPickerBlackBtn;
  Button colorPickerYellowBtn;
  Button colorPickerWhiteBtn;

  String bgImgPath="";
  // toggle button control the view (back or front)
  Button toggleFrontBack;
  Canvas(){
  }

  void drawGUI(){
    stroke(0);
    background(255);
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
    text("ChromoWrap Design Tool", 50, 70 );
    textSize(SLIDER_TEXT_SIZE);
    // text("Brush Size", BRUSH_SLIDRE_X, BRUSH_SLIDRE_Y - SLIDER_TEXT_PADDING_Y );
    
    
    allFibers = readFibersFromFile();
    // importBtn =  new Button(150,430,200,40,color(255,0,0),color(200,50,0),"Load LED positions",4);
    brushBtn = new Button(150,430,200,40,color(255,0,0),color(200,50,0),"Turn off Brush",0);
    addImgBtn = new Button(150,510,200,40,color(255,0,0),color(200,50,0),"Add an Image",1);
    deactivateBtn =  new Button(150,590,200,40,color(255,0,0),color(200,50,0),"Simulate",3);
    startBtn = new Button(150,670,200,40,color(255,0,0),color(200,50,0),"Send Color Pattern",2);
    // colorModeBtn = new Button(400,640,200,40,color(255,0,0),color(200,50,0),"Color Wheel Mode",5);

    colorPickerCyanBtn =  new Button(340,450,70,50,color(0,255,255),color(0,255,255),"",6);
    colorPickerYellowBtn = new Button(470,450,70,50,color(255,255,0),color(255,255,0),"",6);
    colorPickerBlackBtn = new Button(340,550,70,50,color(0,0,0),color(0,0,0),"",6);
    colorPickerWhiteBtn = new Button(470,550,70,50,color(255,255,255),color(255,255,255),"",6);

    // tint(255, 128);
    brush = new Brush(20,INIT_BURSH_COLOR,true);
  }

  void updateGUI(){
    translate(0,0);
    textSize(40);
    fill(0, 0, 0);
    text("ChromoWrap Design Tool", 270, 40 );
    textSize(SLIDER_TEXT_SIZE);
    text("Roatation", IMG_ROTATE_SLIDER_X + SLIDER_TEXT_PADDING_X , IMG_ROTATE_SLIDER_Y + SLIDER_TEXT_PADDING_Y );
    text("Scale", IMG_SCALE_SLIDER_X + SLIDER_TEXT_PADDING_X, IMG_SCALE_SLIDER_Y + SLIDER_TEXT_PADDING_Y );
    text("X", IMGX_SLIDER_X + SLIDER_TEXT_PADDING_X, IMGX_SLIDER_Y + SLIDER_TEXT_PADDING_Y );
    text("Y", IMGY_SLIDER_X + SLIDER_TEXT_PADDING_X, IMGY_SLIDER_Y + SLIDER_TEXT_PADDING_Y );

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
    
    brushBtn.drawButton();
    startBtn.drawButton();
    deactivateBtn.drawButton();
    // importBtn.drawButton();
    addImgBtn.drawButton();
    // colorModeBtn.drawButton();
    if(hideColorWheel){ 
        colorPickerCyanBtn.drawButton();
        colorPickerBlackBtn.drawButton();
        colorPickerYellowBtn.drawButton();
        colorPickerWhiteBtn.drawButton();
    }
   

    brush.radius = (int)brushSize;
 
    if(img != null) {
      img.rotateAngle = picRotation;
      img.height =(int)( picScale/img.width * img.height);
      img.width =(int) picScale;
      img.centerX = imgX;
      img.centerY = imgY;
    }
    if(!hideColorWheel){
        color cnew = color(cw.r(), cw.g(), cw.b());
        // if currently we use the color from color wheel then update the color 
        brush.c = cnew;
    }
    
    
  }
}
