Img img;
// PGraphics pgImg;

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
    
    // PImage imgTmp= loadImage("rose.jpeg");
    // pgImg = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);
    textSize(50);
    fill(0, 0, 0);
    text("ChromoFiber Design Tool", 100, 70 ); 
    // img = new Img( imgTmp,400,500, imgTmp.width,imgTmp.height);
    fibers = createDefaultFibers();
    brushBtn = new Button(900,50,200,50,color(255,0,0),color(200,50,0),"Brush Off",0);
    addImgBtn = new Button(1150,50,200,50,color(255,0,0),color(200,50,0),"Add an Image",1);
    startBtn = new Button(1400,50,200,50,color(255,0,0),color(200,50,0),"Start Color Changing",2);
    // tint(255, 128);
    brush = new Brush(20,INIT_BURSH_COLOR,true);
  }
  void updateGUI(){
    
    
    
    stroke(0);
    noFill();
    rect(100,200,600,600,10);
    if(img != null)img.drawImg();

    // pgImg.beginDraw();
    // pgImg.noStroke();
    // pgImg.fill(INIT_BURSH_COLOR);
    // noStroke();
    // pgImg.ellipse(mouseX-100,mouseY-200,20,20);
    // pgImg.endDraw();
    // image(pgImg, 100, 200); 
    brush.showBrushResult();






    // ellipse(mouseX,mouseY,20,20);
    fibers.updateFibers(900.0f,200.0f,600.0f,600.0f);
    fibers.drawFibers(900.0f,200.0f,600.0f,600.0f);

    
    addImgBtn.drawButton();
    brushBtn.drawButton();
    startBtn.drawButton();
    
  }



 

}