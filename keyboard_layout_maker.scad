// constants 
ROWS=5;
COLS=15;
PLATE_THICKNESS=3;
X_PADDING=5;
Y_PADDING=5;
STD_KEY_WIDTH=14.3;
STD_KEY_HEIGHT=14.6;
STD_CTC_DIFF_X= X_PADDING + STD_KEY_WIDTH;
STD_CTC_DIFF_Y= Y_PADDING + STD_KEY_HEIGHT;
MAX_X = X_PADDING + COLS*STD_CTC_DIFF_X;
MAX_Y = Y_PADDING + ROWS*STD_CTC_DIFF_Y;
$fn=100;

// zero indexed row offset for y
function y_row_offset(idx) = Y_PADDING + idx*(STD_CTC_DIFF_Y);

// getting x offset for given num_keys 
function x_key_offset(num_keys,size=1) = num_keys*(STD_CTC_DIFF_X*size);

function key_width(size) = ( 
  size 
    ? STD_KEY_WIDTH*size + floor((size-1)*X_PADDING) 
    : 0
);


// offset for single key larger than 1u 
function large_key_offset(size) = (
  2*X_PADDING 
  + STD_KEY_WIDTH*size 
  + floor((size-1)*X_PADDING)
); 

// standard switch mounting hole 
module sized_switch_mount(trans_vect,size=1) {
   translate(trans_vect)
     cube([
       key_width(size),
       STD_KEY_HEIGHT,
       PLATE_THICKNESS + 0.2
      ]);   
};

// large key right adjusted 
module large_key_right (key_size, row, hole_size, offset=0) {
  sized_switch_mount(
    [
      ( X_PADDING 
        + ((key_size-hole_size)*STD_KEY_WIDTH) / 2
        + ( offset ? key_width(offset) + 5 : 0 )
      ), 
      y_row_offset(row),
     -0.1
    ],
    hole_size
  );
}

// large key left adjusted
module large_key_left (key_size, row, hole_size, offset=0) {
  sized_switch_mount(
    [ 
      MAX_X - (
        X_PADDING 
        + ((key_size-hole_size)*STD_KEY_WIDTH) / 2
        + key_width(hole_size)
        + ( offset ? key_width(offset) + 5 : 0 ) 
      ),
      y_row_offset(row),
      -0.1
    ],
    hole_size
  );
}


// row of consecutive 1u keys 
module one_u_row(x_edge_offset, y_edge_offset, num_keys) {
  end_range = -1 + x_edge_offset + (STD_CTC_DIFF_X*num_keys);
  for (i=[x_edge_offset:STD_CTC_DIFF_X:end_range]) {
    sized_switch_mount([i,y_edge_offset, -0.1]);
  }
};

module cons_xu_row( x_edge_offset, y_edge_offset, size, numkeys) {
  end_range = -1 + x_edge_offset + (STD_CTC_DIFF_X*num_keys*size);
  for (i=[x_edge_offset:STD_CTC_DIFF_X*size:end_range]) {
    sized_switch_mount([i,y_edge_offset,-0.1], size); 
  }  
};

// bare plate with no holes 
module plate( rows , cols , height=PLATE_THICKNESS) {
  cube([
    MAX_X,
    MAX_Y,
    height
  ]);
};

module rounded_plate ( rows, cols, radius, height=PLATE_THICKNESS) {
  hull () {
    
    // end points for the plate 
    points = [ 
      [ radius , MAX_X-(radius*2)] , 
      [ radius , MAX_Y-(radius*2)]
    ];
  
    // placing cylinders 
    for( i=[0:1:1] ) {
     for ( j=[0:1:1]) {
      translate([points[0][i],points[1][j],0])
        cylinder(r=radius, h=height); 
    }};
    
  }
};

module sixty_ansi_layout () {
    // row 0 
    large_key_right(key_size=2,row=0,hole_size=2);
    one_u_row(
      x_edge_offset=large_key_offset(2),
      y_edge_offset=y_row_offset(0),
      num_keys=13
    );
  
    // row 1 
    large_key_right(key_size=1.5,row=1,hole_size=1);
    one_u_row(
      x_edge_offset=large_key_offset(1.5),
      y_edge_offset=y_row_offset(1),
      num_keys=12
    );
    large_key_left(key_size=1.5,row=1,hole_size=1);
    
    // row 2
    large_key_right(key_size=2.25,row=2,hole_size=2.25);
    one_u_row(
      x_edge_offset=large_key_offset(2.25),
      y_edge_offset=y_row_offset(2),
      num_keys=11
    );
    large_key_left(key_size=1.75,row=2,hole_size=1);
  
    // row 3 
    large_key_right(key_size=2.75,row=3,hole_size=2.75);
    one_u_row(
      x_edge_offset=large_key_offset(2.75),
      y_edge_offset=y_row_offset(3),
      num_keys=10
    );
    large_key_left(key_size=2.25, row=3, hole_size=2.25);
  
    // row 4
    large_key_right(key_size=6.25, row=4, hole_size=6.25, offset=4*1.25);
    large_key_right(key_size=1.25, row=4, hole_size=1);
    large_key_right(key_size=1.25, row=4, hole_size=1, offset=1.25);
    large_key_right(key_size=1.25, row=4, hole_size=1, offset=2.5);
    large_key_right(key_size=1.25, row=4, hole_size=1, offset=3.75);
    large_key_left (key_size=1.25, row=4, hole_size=1);
    large_key_left (key_size=1.25, row=4, hole_size=1, offset=1.25);
    large_key_left (key_size=1.25, row=4, hole_size=1, offset=2.5);
}; 

// 60% keyboard plate 
module sixty_ansi_plate () {
  difference (){
    rounded_plate(ROWS,COLS, 0.5);
    sixty_ansi_layout(); 
  };
};

module sixty_case() {
  difference () {
    cube([
      MAX_X + 4,
      MAX_Y + 4,
      12
    ]);
    rotate(0, [1,0,0]) {
    translate([2,2,10.5])
    rounded_plate(ROWS,COLS,0.6,20);
     
    translate([3.5,3.5,2])
    cube([
      MAX_X - 3,
      MAX_Y - 3,
      20
    ]);
    }
  }
};

//sixty_case();
//sixty_ansi_plate(ROWS,COLS, 0.5);

//translate([0,105,0])
//  sixty_case();

/* this is like a stand to incline the keyboard
translate([305,0,0])
difference () { 
#cube([MAX_X + 6, MAX_Y + 4, 20]);
translate([1,2,0])
rotate(10,[1,0,0])
  cube([
    MAX_X + 4,
    MAX_Y + 4,
    200
  ]);
};
*/