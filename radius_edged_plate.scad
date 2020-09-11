include <keyboard_layout_maker.scad>

$fn=100;

CASE_PADDING_X = 4; 
CASE_PADDING_Y = 4; 
CASE_PADDING_Z = 2; 
INCLINE_ANGLE = 10; 
SWITCH_BOTTOM_HEIGHT = 8.5; 
PLATE_LIP_SIZE = 3; 

function sq(x) = x*x; 

module rounded_ansi_plate() { 
  difference () { 
    rounded_plate(ROWS,COLS,0.5);
    sixty_ansi_layout () ; 
  };
};  

module rounded_case_block (ang=INCLINE_ANGLE) { 
  LENGTH = MAX_X + CASE_PADDING_X*2;
  WIDTH  = MAX_Y + CASE_PADDING_Y*2; 
  HEIGHT = 
    PLATE_THICKNESS
    + SWITCH_BOTTOM_HEIGHT
    + CASE_PADDING_Z ;
      
  hull () {
    // base shape  
    cube([
      LENGTH,
      WIDTH,
      HEIGHT
    ]);
    
    // finding the length of the top side with the incline   
    opp = (WIDTH * tan(ang));
    hyp = sqrt(sq(opp) + sq(WIDTH)); 
      
      
    translate([0,0,HEIGHT ])   
    rotate([ang,0,0]) 
    cube([
      LENGTH, 
      hyp,
      0.1
    ]);
  } 
} ;

module rounded_case ( ang=INCLINE_ANGLE ) { 
  HEIGHT = 
    PLATE_THICKNESS
    + SWITCH_BOTTOM_HEIGHT
    + CASE_PADDING_Z ;
    
  difference () { 
    // base block 
    rounded_case_block(ang) ;
      
    // plate cutout 
    translate([
      0,
      CASE_PADDING_Y*cos(ang),
      CASE_PADDING_Y*sin(ang)  
    ])
    translate([CASE_PADDING_X,0,HEIGHT-PLATE_THICKNESS]) 
    rotate([ang, 0,0])
    rounded_plate(ROWS, COLS, 1) ;
    
    // negative space for internals
    // just realized its gonna take some trig ....  
    translate([
      (CASE_PADDING_X + PLATE_LIP_SIZE), 
      (CASE_PADDING_Y + PLATE_LIP_SIZE)*cos(ang), 
      CASE_PADDING_Z])
    cube([
      MAX_X-PLATE_LIP_SIZE*2,
      (MAX_Y-PLATE_LIP_SIZE*2)*cos(ang),
      30
    ]);
    
    
    // this is bad but bear with me 
    LENGTH = MAX_X + CASE_PADDING_X*2;
    WIDTH  = MAX_Y + CASE_PADDING_Y*2; 
    HEIGHT = 
      PLATE_THICKNESS
      + SWITCH_BOTTOM_HEIGHT
      + CASE_PADDING_Z ;
      
    #translate([CASE_PADDING_X,CASE_PADDING_Y,CASE_PADDING_Z ])
    scale([
      // x -> should be == length - 2*case_padding_x
      MAX_X/LENGTH,  
      // y -> should be == width  - 2*case_padding_y
      MAX_Y/WIDTH, 
      // z -> should be == height - 2*case_padding_z 
      ((HEIGHT-2*CASE_PADDING_Z)/HEIGHT) - 0.15   
    ]) { rounded_case_block(ang+6); };
  }
}; 

rounded_case (10) ; 