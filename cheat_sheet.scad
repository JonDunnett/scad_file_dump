// facet number kind of like anti aliasing // resolution
$fn=100;

// shapes 
cube([10,10,10]);
// % for transparency 
%sphere(10);
cylinder( r1=5, r2=5,h=10);

// translations 
translate([10,0,0]) cube([1,1,1]);

// # sign for highlighting 
#translate([-15,0,0]) cube([1,1,10]);

// rotations -- kinda the same deal as translations 
rotate(a=90,v=[1,0,0]) cylinder(r1=10,r2=10,h=20);

// can combine these 
rotate(a=90, v=[1,1,0]) translate([20,20,20]) cube([1,2,3]);

