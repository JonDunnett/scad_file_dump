// constants 
ROWS=5;
COLS=15;
PLATE_THICKNESS=1.5;
X_PADDING=5;
Y_PADDING=5;
STD_KEY_WIDTH=14;
STD_KEY_HEIGHT=14;
STD_CTC_DIFF_X= X_PADDING + STD_KEY_HEIGHT;
STD_CTC_DIFF_Y= Y_PADDING + STD_KEY_WIDTH;
MAX_X = X_PADDING + COLS*STD_CTC_DIFF_X;
MAX_Y = Y_PADDING + ROWS*STD_CTC_DIFF_Y;

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
module plate( rows , cols ) {
  cube([
    MAX_X,
    MAX_Y,
    PLATE_THICKNESS
  ]);
};

// 60% keyboard plate 
module sixty_ansi_layout () {
  difference (){
    plate(ROWS,COLS);
  
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
};

translate([5,5,0])
  sixty_ansi_layout(); 