$fn=100;
/*
points = [ [0,0,0], [10,0,0], [0,10,0], [10,10,0] ];
 
module rounded_box(points, radius, height){
    //hull(){
        for (p = points){
            translate(p) cylinder(r=radius, h=height);
        }
    //}
}

rounded_box(points, 2, 2); 
*/

/*
polyhedron(
  points=[
    [1,1,0],[0,1,0],[0,0,0], // triangle 1
    [1,1,1],[0,1,1],[0,0,1]  // triangle 2
  ],
  faces=[
    // triangle fill
    [0,1,2],[3,4,5],
    // rectangle fill
    [0,1,4,3], [0,2,5,3], [1,2,5,4]
  ]
);
*/

// soh cah toa 

module triangle (a,b,ang) {
  polyhedron(
    points=[
      [0,0,0],                    // vertex a-b
      [a*cos(ang),a*sin(ang),0],  // vertex b-c
      [b,0,0]                     // vertex c-a
    ],
    faces=[
      // triangular fill 
      [1,0,2] // , [] 
      // rectangular fill 
      //[], [] , [] , []
    ]
  );
};

triangle(5,5,60); 
