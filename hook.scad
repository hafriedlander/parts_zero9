
include <../hfscad/utils.scad>;
include <../hfscad/shapes.scad>;

use <../hfscad/thirdparty/nutsnbolts/cyl_head_bolt.scad>;

$fn=60;

stem=[34.5,62];
clampZ=25;
wall=0.4*8;
boltWall=0.4*12;
boltClampW=11;

module stem() {
    hull() {
        cylinder(d=stem.x, h=clampZ, center=true);
        tY(stem.y - stem.x) cylinder(d=stem.x, h=clampZ, center=true);
    }
}

module loop() {
    tY((stem.y-stem.x)/-2) {
        difference() {
            hull() {
                cylinder(d=stem.x + wall*2, h=clampZ, center=true);
                tY(stem.y - stem.x) cylinder(d=stem.x + wall*2, h=clampZ, center=true);
            }   
            epsilon(Z) stem();
        }

        // LED slit key
        tY(-stem.x/2) linear_extrude(clampZ, center=true) roundedSquare([7, 4], center=true, r=1);
    }

    symmetricX() tX(stem.x/2 + (wall+boltClampW)/2) cube([wall + boltClampW, boltWall*2, clampZ], center=true);
}

module loopWithBoltHoles() {
    difference() {
        loop();
        symmetricZ() symmetricX() tX(stem.x/2 + wall + boltClampW/2 - 0.5) tZ(clampZ/4) {
            r(90*X) cylinder(d=3.2, h=20, center=true);
            tY(boltWall+2.5-2.4) r(30*Y) r(90*X) tZ(2.5) nutcatch_parallel("M5");
        }
    }   
}

module hook() {
    difference() {
        cube([boltWall*2, 8*2, clampZ], center=true);
        tZ(5) {
            // Angle
            tY(3.3) tZ(-1) r(-35*X) cube([boltWall*2+_e, 8, 22], center=true);
            // Vertical
            //tY(-1.87) tZ(-6.3) cube([wall*2+_e, 8, 6], center=true);
            // Cut sharp tip
            tY(16/2) tZ(-1.2) cube([boltWall*2+_e, 5, 1.5], center=true);
            tY(16/2-3.2) tZ(clampZ/2-4) cube([boltWall*2+_e, 1.5, 5], center=true);
        }
    }
}

tY(stem.y/2 + 9.5) hook();

intersection() {
    loopWithBoltHoles();
    tY(25) cube([70, 50, clampZ*2], center=true);
}

tY(-1) intersection() {
    loopWithBoltHoles();
    tY(-25) cube([70, 50, clampZ*2], center=true);
}
