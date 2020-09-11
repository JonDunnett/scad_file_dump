$fn = 100;

function in(x) = x*25.4;

// 4/16 width 
// 6/16 length 

HOLE_WIDTH = 13.86;
HOLE_LENGTH = 18.82;
CASE_HEIGHT = 110.00;
CASE_DEPTH = 21.00;
CASE_WIDTH = 52.06; 
CHAMFER_DEPTH = (CASE_HEIGHT - 11.68) / 2;
WALL_THICKNESS_X = 3.60;
WALL_THICKNESS_Y = 3.64; 
FLAT_EDGE_OFFSET = 17.26;


// 49.32
// 51.40
FUNNEL_RADIUS_1 = HOLE_WIDTH/2;
FUNNEL_RADIUS_2 = (49.32-(HOLE_LENGTH-HOLE_WIDTH)/2)/2;
FUNNEL_HEIGHT = 30-(HOLE_WIDTH/2); 


module hole_shape() {
  translate([HOLE_WIDTH/-2, HOLE_WIDTH/-2])
  difference () {
    translate([HOLE_WIDTH/2, HOLE_WIDTH/2, 0])
    hull() {
      cylinder(r=HOLE_WIDTH/2, h=HOLE_WIDTH/2);
      translate([
        HOLE_LENGTH - HOLE_WIDTH,
        0,
        0
      ])
      cylinder(r=HOLE_WIDTH/2, h=HOLE_WIDTH/2);
    }
    cube([HOLE_LENGTH - FLAT_EDGE_OFFSET,HOLE_WIDTH,HOLE_WIDTH/2]);
  }   
}

module hole() { 
  difference() { 
    hole_shape();
    translate([(3*HOLE_WIDTH)/20,(3*HOLE_HEIGHT)/20,-0.2])
    scale([0.85,0.85,1.1]){
         
        hole_shape(); 
    };
  };
}

module grinder_mount() {
  difference() {
    cylinder(r=51.40/2,h=7.20);
    cylinder(r=49.32/2,h=7.20);
  }
}

module funnel_volume() {
  hull () {
    translate([
      ((HOLE_LENGTH-HOLE_WIDTH)/2)/2,
      0,
      30-HOLE_WIDTH/2])
    cylinder(r=51.40/2,h=7.20);
    funnel(); 
  }   
}

module insert() { 
  hole();
    
  translate([(HOLE_LENGTH-HOLE_WIDTH)/2,0,30]) 
  grinder_mount();
  //hull() {
    translate([0,0,HOLE_WIDTH/2])
    funnel();
    translate([
      49.26-(49.26-1.16-(HOLE_LENGTH-HOLE_WIDTH)/2),
      0,
      HOLE_WIDTH/2
    ])
    funnel(); 
  //}
}

module funnel () {
  hull() {
    cylinder(
      r1=FUNNEL_RADIUS_1,
      r2=FUNNEL_RADIUS_2,
      h=FUNNEL_HEIGHT
    );
    translate([
      (49.32-(49.32-(HOLE_LENGTH-HOLE_WIDTH)))/2,
      0,0])
    cylinder(
      r1=FUNNEL_RADIUS_1,
      r2=FUNNEL_RADIUS_2,
      h=FUNNEL_HEIGHT
    );
    hole();
    translate([0.92/2,0,HOLE_WIDTH/2])
    scale([1.10,1,1]) { 
    hole(); 
  };
    
  }    
}

module funnel_cutout() {
  difference() { 
    funnel_volume();
    translate([
      ((HOLE_LENGTH-HOLE_WIDTH)/2)/2,
      0,
      30-HOLE_WIDTH/2
    ])
    cylinder(r=49.32/2,h=7.20);
    hull() {
      cylinder(
        r1=FUNNEL_RADIUS_1-(1.16),
        r2=FUNNEL_RADIUS_2-(1.16),
        h=FUNNEL_HEIGHT
      );
      translate([
        (49.26-(49.26-(HOLE_LENGTH-HOLE_WIDTH)))/2 ,
        0,0])
      cylinder(
        r1=FUNNEL_RADIUS_1-(1.16),
        r2=FUNNEL_RADIUS_2-(1.16),
        h=FUNNEL_HEIGHT
      );
    }
  }
}

translate([1.16,0,HOLE_WIDTH])
funnel_cutout();


union () {
  hole();
  translate([0,0,HOLE_WIDTH/2])
  hole();
    translate([0.92/2,0,HOLE_WIDTH/2])
    scale([1.10,1,1]) { 
    hole(); 
    }
}
/*
module funnel () {
  difference() { 
      cylinder(
        r1=HOLE_WIDTH/2,
        r2=49.26-1.16-(HOLE_LENGTH-HOLE_WIDTH)/2,
        h=30-(HOLE_WIDTH/2)
      );
      cylinder(
        r1=(HOLE_WIDTH/2)-1.18,
        r2=49.26-1.16-((HOLE_LENGTH-HOLE_WIDTH)/2)-1.16,
        h=31-(HOLE_WIDTH/2)  
      );
  } 
}*/

//insert(); 
/*
//rotate([180,0,0])
//translate([20,20,0])
insert();

//translate([4,0,8])

//difference() { 
//  cylinder(r1=in(4/16),r2=in(2),h=in(2));
//  scale([0.95,0.95,1]) {cylinder(r1=in(4/16),r2=in(2),h=in(2));};
//}

module funnel() {
  hull () { 
    cylinder(r1=in(3/16),r2=in(2),h=in(2));
      union () { 
      translate([0,0,0])
      hole();
      scale([1.02,1.02,1]){
        translate([0.1,0,0])
        hole();
      };
      scale([1.05,1.05,1]) {
        translate([0.2,0,0])  
        hole();
      };
    }
  }
}

translate([0,0,8])
difference() {
  funnel();
  scale([0.95,0.95,1]) {  
    funnel();
  };
  
}
*/