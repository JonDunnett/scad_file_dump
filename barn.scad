
function ft(x) = x*12;
function yd(x) = ft(x)*3;
function in(x) = x;
function cc(x) = x/255;
// foundation dimensions  
FOUNDATION_X = yd(30);
FOUNDATION_Y = yd(20);
FOUNDATION_Z = in(10); 

module vertical_support_beam (l) {
  color("Brown")
  translate([0,0,-1*l/3])
    cube([in(4),in(4),l]);
}

module two_by_four(height) {
  cube([2,4,height]);   
}

module foundation(l,w,h) {
  color("Grey")
  translate([0,0,-1*h])
  cube([l,w,h]);
}

module four_corner_support(x,y,z) {
  for (i=[0:1]) {
    for (j=[0:1]) {
      translate([
        i* (x - in(4)),
        j* (y - in(4)),
        0
      ]) 
      vertical_support_beam(z);
    }
  }   
}

module wall( length, height, depth, intv) {
  color([cc(135), cc(115), cc(23)])
  difference () {
    cube([length, depth, height]);
    translate([2,-0.1,2])
    cube([length - 4, depth+0.2, height - 4]);    
  }
  color([cc(235), cc(200), cc(42)])
    translate([2,0,2])
    two_by_four(height-4);
  
  // 16 has more options 
  interval = (
    (length % 12 == 0)
    || (length % 12 == 4)
    || (length % 12 == 8)
  ) ? 16 : 1000000;
    
  //for(i=[2:intv:length-4]){
  //  color([cc(235), cc(200), cc(42)])
  //  translate([i,0,2])
  //  cube([2,4,height-4]);   
  //}
}

module room( x, y, z) {
//not working -- needs revision 
  for(i=[0:1]){
    for(j=[0:1]){
      wall_length = i!=j ? y : x;
      rotation  = abs(i-j)*90;
      translate([
          0, // i* (x - in(4)),
          j* (y - in(4)),
          0  
        ])
        rotate([0,0,rotation])
        
        translate([in(4),0,0])
        wall( wall_length, z, in(4) );
    }
  }   
}


module doorway(width, height) { 
  vertical_support_beam(height);
  translate([width-4,0,0])
    vertical_support_beam(height);
  
  translate([0,0,height - (height/3) -2])
  cube([width,4,4]);
}

module barn () { 
  // foundation 
  foundation(yd(30),yd(20),in(10));

  // corner supports 
  four_corner_support(FOUNDATION_X, FOUNDATION_Y, ft(16));

  // garage
  garage_x_offset = yd((30-15)/2);
  garage_x = yd(15); 
  translate([garage_x_offset,0,0])
    four_corner_support(garage_x,FOUNDATION_Y, ft(16));
  
  // garage bay 1
  translate([garage_x_offset + yd(5/3),0,0])
    doorway(yd(5), ft(12));
  
  // garage bay 2
  translate([garage_x_offset + yd(5/3)*2 + yd(5),0,0])
    doorway(yd(5), ft(12)); 

  // walls 
  translate([in(4),in(4),0])
  rotate([0,0,90])
    wall(yd(10) - in(12), ft(10), in(4), 18);
  
  translate([0,yd(10) - in(6),0])
    vertical_support_beam(ft(16));
  translate([0,in(4) + yd(10) - in(6), 0])
    vertical_support_beam(ft(16));
    

}

barn();