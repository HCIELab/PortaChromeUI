// By Yixiao Kang(kyx999@sjtu.edu.cn)
// define the const used in the application

// global settings
int c = 20;

int WINDOW_WIDTH = 1400;
int WINDOW_HEIGHT = 800;
// the LED number is limited to 70 right now, because the data will be lost during transmission to Arduino, need further investigation on how to perserve the data.
int MAX_LED = 144;


// widget settings
int SUB_WIN_SPACING = 0; // spacing between two major sub window.
int SUB_WIN_HEIGHT = 270; 
int SUB_WIN_WIDTH = 480;

int PAINT_WIN_LEFT_TOP_X = 50;
int PAINT_WIN_LEFT_TOP_Y = 100;
int PAINT_WIN_CENTER_X = PAINT_WIN_LEFT_TOP_X + SUB_WIN_WIDTH/2 ; 
int PAINT_WIN_CENTER_Y = PAINT_WIN_LEFT_TOP_Y + SUB_WIN_HEIGHT/2; 
int MAX_BRUSH_SIZE = 30;

// fiber settings
int FIBER_NUMBER = 1;
float PIXEL_WIDTH = 0.3f;
float PIXEL_HEIGHT = 7.0f;
float HEX_RADIUS = 45.0f;

int HORIZONTAL_NUM = 6;
int VERTICAL_NUM = 6;
float SHIFT_X = WINDOW_WIDTH/2 - HEX_RADIUS * HORIZONTAL_NUM/2;
float SHIFT_Y = SUB_WIN_HEIGHT - HEX_RADIUS * VERTICAL_NUM/2;
float HORIZONTAL_GPA = HEX_RADIUS / 4;
float VERTICAL_GPA = HEX_RADIUS / 2;


// sliders
int SLIDER_TEXT_PADDING_Y = 10;
int SLIDER_TEXT_PADDING_X = -50;
int SLIDER_TEXT_SIZE = 15;
int BRUSH_SLIDRE_X = 50;
int BRUSH_SLIDRE_Y = 520;
int BRUSH_SLIDRE_WID = 200;
int BRUSH_SLIDRE_HEIGHT = 20;

int IMG_ROTATE_SLIDER_X = 350;
int IMG_ROTATE_SLIDER_Y = 650;
int IMG_ROTATE_SLIDER_WID = 150;
int IMG_ROTATE_SLIDER_HEIGHT = 20;
float MAX_ROTATE = 6.28;

int IMG_SCALE_SLIDER_X = 350;
int IMG_SCALE_SLIDER_Y = 675 ;
int IMG_SCALE_SLIDER_WID = 150;
int IMG_SCALE_SLIDER_HEIGHT = 20;
float MIN_SCALE = 30.0f;
float MAX_SCALE = 500.0f;

int IMGX_SLIDER_X = 350;
int IMGX_SLIDER_Y = 600 ;
int IMGX_SLIDER_WID = 150;
int IMGX_SLIDER_HEIGHT = 20;
int MIN_X = PAINT_WIN_LEFT_TOP_X;
int MAX_X = PAINT_WIN_LEFT_TOP_X + SUB_WIN_WIDTH;

int IMGY_SLIDER_X = 350;
int IMGY_SLIDER_Y = 625 ;
int IMGY_SLIDER_WID = 150;
int IMGY_SLIDER_HEIGHT = 20;
int MIN_Y = PAINT_WIN_LEFT_TOP_Y;
int MAX_Y = PAINT_WIN_LEFT_TOP_Y + SUB_WIN_HEIGHT;


int FIBER_WIN_LEFT_TOP_X = PAINT_WIN_LEFT_TOP_X + SUB_WIN_SPACING; 
int FIBER_WIN_LEFT_TOP_Y = PAINT_WIN_LEFT_TOP_Y;

int IMG_MOVE_SPEED=5;
int IMG_SCALE_SPEED=5;
color INIT_BURSH_COLOR = color(197,156,245);
float IMG_ROTATE_SPEED = 3.14/30; 

int BTN_TEXT_SIZE =20;

// other settings
float INIT_PIC_WIDTH = 200.0f; 
float[][] FULL_DEACTIVATION_SPEED = 
{ {1/467,1/712,1/687},
  {1/1500,1/242,1/177},
  {1/10000,1/900,1/20} };
  


  