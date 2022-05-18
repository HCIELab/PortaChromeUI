class Canvas{

  Fibers fibers;
  Button addImgBtn;
  Img img;
  Canvas(){

  }



  void drawGUI(){
    
    fibers = createDefaultFibers();
    fibers.drawFibers(0.0f,0.0f,300.0f,300.0f);
    addImgBtn = new Button(500,50,150,50,color(255,0,0),color(200,50,0),"Add an image");
    img = new Img( loadImage("rose.jpeg"),WINDOW_WIDTH/2,WINDOW_HEIGHT/2 );
   
  }
  void updateGUI(){
    
   
    img.changeImg(mouseX,mouseY, img.width,img.height);
    img.drawImg();
    fibers.drawFibers(0.0f,0.0f,300.0f,300.0f);
    addImgBtn.drawButton();
  }



 

}