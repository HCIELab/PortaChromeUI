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
    
    PImage imgTmp= loadImage("rose.jpeg");
    pgImg = createGraphics(SUB_WIN_WIDTH,SUB_WIN_HEIGHT);
    
    img = new Img( imgTmp,400,500, imgTmp.width,imgTmp.height);
    fibers = createDefaultFibers();
    addImgBtn = new Button(500,50,150,50,color(255,0,0),color(200,50,0),"Add an image");
    // tint(255, 128);
   
  }
  void updateGUI(){
    
    pgImg.beginDraw();
    // pgImg.fill(40,255,255);
    stroke(0);
    noFill();
    rect(100,200,600,600,10);
    img.drawImg();
    pgImg.noStroke();
    pgImg.fill(40,255,255);
    noStroke();
    pgImg.ellipse(mouseX-100,mouseY-200,20,20);
    // img.changeImg(mouseX,mouseY,img.width,img.height);

   
    // img.drawImgOnPg(pgImg);
    pgImg.endDraw();
    image(pgImg, 100, 200); 
    ellipse(mouseX,mouseY,20,20);
    fibers.updateFibers(900.0f,200.0f,600.0f,600.0f);
    fibers.drawFibers(900.0f,200.0f,600.0f,600.0f);

    
    addImgBtn.drawButton();
    
  }



 

}