$fn=200;


module driver() { 
  difference() {
    cylinder(r=4,h=17);
    for (i=[0:1:2]) {
      rotate([0,0,i*120])
      translate([-2,-1*(2.31/2), 0])
      cube([4,2.31,15]);
    }
  }
}

module driver_shaft () {
 cylinder(r=6.28/2,h=50);
}

module phillips_head() {
  intersection() { 
    union() { 
      translate([-0.5,-6.28/2,0])
      cube([1,6.28,6.5]);
      translate([-6.28/2,-0.5,0])
      cube([6.28,1,6.5]);
    } 
    union() {
      translate([0,0,4.52])
      cylinder(r=6.28/2,h=20); 
      cylinder(r1=0,r2=6.28/2,h=4.52);
    }
  }
}


translate([0,0,17])
difference() {
  cylinder(r=4,h=23);
  translate([0,0,6.28])
  driver_shaft();
  #phillips_head();

}  


driver();



//translate([0,0,50+30])
//sphere(r=30);

//translate([0,0,50+30])
//cylinder(r=30,h=50);