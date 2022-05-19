Img img;
PGraphics pgImg;
PGraphics pgFiber;

class Canvas{

  Fibers fibers;
  Button addImgBtn;
  
  Canvas(){

  }



  void drawGUI(){
    stroke(0);
    rect(100,200,600,600);
    PImage imgTmp= loadImage("rose.jpeg");
    // pgImg = createGraphics(WINDOW_WIDTH,WINDOW_HEIGHT);
    img = new Img( imgTmp,0,0, imgTmp.width,imgTmp.height);
    fibers = createDefaultFibers();
    addImgBtn = new Button(500,50,150,50,color(255,0,0),color(200,50,0),"Add an image");
    // tint(255, 128);
   
  }
  void updateGUI(){
    
    // pgImg.beginDraw();
    // pgImg.fill(255);
    // pgImg.background(255);
    stroke(0);
    rect(100,200,600,600,10);
    // rect(900,200,600,600,10);
    img.changeImg(mouseX,mouseY,img.width,img.height);

    img.drawImg();
    // img.drawImgOnPg(pgImg);
    // pgImg.endDraw();
    // image(pgImg, 0, 0); 
    fibers.updateFibers(900.0f,200.0f,600.0f,600.0f);
    fibers.drawFibers(900.0f,200.0f,600.0f,600.0f);

    
    addImgBtn.drawButton();
    
  }



 

}