$fn=200;

module fitting () {
  cube([1.18,5.50,3.64]) ;
   
  translate([(1.18-1.72)/2,0,0])
  cube([1.72,1.38,3.64]) ;  
}

module handle() {
  difference() {
    translate([0,0,4.02])
    cylinder(r=31.34/2,h=4);
    translate([0,0,(28) + 4.02])
    difference() {
      sphere(r=28);
  
      translate([-35,-4.5,-35])  
      cube([70,9,70]);
    }
    translate([-10,0,8.02-0.5])
    cylinder(r=4.5/2,h=0.5);
  }
  
  intersection() {
    translate([-31.34/2,-9/2,8.02])
    cube([31.34,9,4]);
    translate([0,0,-28 + 8.02 + 4])
    sphere(r=28);
  }
  
} 

module dial() { 
  difference() {
    cylinder(r=31.34/2,h=4.02);
    translate([-1.18/2,-5.50/2,0])
    fitting();
  }
}

module rotation_limiter() {
  translate([0,(31.34/2)-(1.38/2),-1.5])
  cylinder(r=1.38/2,h=1.5);
}






module main() {
  dial();
  rotation_limiter();   
  handle();
}


main();