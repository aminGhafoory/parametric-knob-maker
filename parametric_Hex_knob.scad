//knob parameters
KNOB_HEIGHT=15;
KNOB_DIAM=30;

//screw parameters
SCREWHEAD_FACETOFACE=8;
SCREWHEAD_DEPTH=12;
THRU_HOLE_DIAM=4;

//grippy cutouts parameters
NUM_GRIP_CUTOUTS=20;
GRIP_CUTOUT_DIAM=4;
CUTOUT_RADIUS_ADJ=1;

module FaceToFaceHex(width,height){

    cube([width/sqrt(3),width,height],center = true,$fn=64);
    rotate([0,0,120])cube([width/sqrt(3),width,height],center = true);
    rotate([0,0,240])cube([width/sqrt(3),width,height],center = true);

}
// a=angle, r=radius of rotation
module rotate_on_circle(angle, radius) {
    dx=radius*sin(angle);
    dy=radius*cos(angle);
    translate([dx,dy,0])
    children();   
}

difference(){

        //Knob
        union(){
            translate([0, 0, -(((KNOB_HEIGHT-SCREWHEAD_DEPTH)/2)+0.01)]) 
                cylinder(r=KNOB_DIAM/2, h=KNOB_HEIGHT, center=true,$fn=64);
            translate([0, 0, -(((KNOB_HEIGHT-SCREWHEAD_DEPTH+KNOB_HEIGHT)/2))]) {
                cylinder(r=KNOB_DIAM/4, h=KNOB_HEIGHT/2, center=true,$fn=64);
            }
            
        };

        //screw
        union(){
            //screwHead
            FaceToFaceHex(SCREWHEAD_FACETOFACE,SCREWHEAD_DEPTH);
            //screwHole
            translate([0, 0, -(((KNOB_HEIGHT+SCREWHEAD_DEPTH)/2)+0.001)]) 
                cylinder(r=THRU_HOLE_DIAM/2, h=KNOB_HEIGHT+KNOB_HEIGHT/2+0.001, center=true,$fn=64);
            };

        //grippyCutouts
        for(i=[1:NUM_GRIP_CUTOUTS]){

            rot_angle=(360/NUM_GRIP_CUTOUTS)*i;
            translate([0,0,-(((KNOB_HEIGHT-SCREWHEAD_DEPTH)/2)+0.01)])
                rotate_on_circle(rot_angle,(KNOB_DIAM/2)+CUTOUT_RADIUS_ADJ)
                cylinder(r=GRIP_CUTOUT_DIAM/2,h=KNOB_HEIGHT+0.01,center=true,$fn=64);
        };
        
        //top filet
    translate([0, 0,-(((KNOB_HEIGHT-SCREWHEAD_DEPTH)/2)-0.1)])
            rotate_extrude()
                    polygon(points = [[KNOB_DIAM,KNOB_HEIGHT], [0,KNOB_HEIGHT+2],[0,KNOB_HEIGHT],[KNOB_DIAM/1.29,0]],$fn=100);
    //down filet
    translate([0, 0,-(((KNOB_HEIGHT-SCREWHEAD_DEPTH)/2)+0.1)])
            rotate_extrude()
                    polygon(points = [[-KNOB_DIAM,-KNOB_HEIGHT], [0,-KNOB_HEIGHT-2],[0,-KNOB_HEIGHT],[-KNOB_DIAM/1.29,0]],$fn=100);

}

    
