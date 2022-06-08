// global settings
int c = 20;

int WINDOW_WIDTH = 1400;
int WINDOW_HEIGHT = 800;

// fiber settings
float PIXEL_WIDTH = 5.0f;
float PIXEL_HEIGHT = 5.0f;

// widget settings
int SUB_WIN_SPACING = 700; // spacing between two major sub window.
int SUB_WIN_HEIGHT = 500; 
int SUB_WIN_WIDTH = 500;


int PAINT_WIN_LEFT_TOP_X = 50;
int PAINT_WIN_LEFT_TOP_Y = 200;
int PAINT_WIN_CENTER_X = PAINT_WIN_LEFT_TOP_X + SUB_WIN_WIDTH/2 ; 
int PAINT_WIN_CENTER_Y = PAINT_WIN_LEFT_TOP_Y + SUB_WIN_HEIGHT/2; 

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
  