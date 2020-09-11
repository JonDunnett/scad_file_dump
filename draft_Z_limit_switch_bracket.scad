$fn=100;

function in_to_mm(x) = x*(25.4);

PLATE_X = in_to_mm(1.5);
PLATE_Y = in_to_mm((8+5)/8);
PLATE_Z = in_to_mm(1/8);
SCREW_HOLE_RADIUS = in_to_mm((2/8)/2);

module screw_hole () {
  cylinder(r=SCREW_HOLE_RADIUS,h=PLATE_Z); 
};

difference() { 
  cube([in_to_mm(1.5),in_to_mm((8+5)/8),in_to_mm(1/8)]);
  translate([in_to_mm(3/8),in_to_mm(3/8),0])
    screw_hole();
  #translate([
    in_to_mm(3/8),
    in_to_mm(9.5/8),
    0
  ])
    screw_hole();
}