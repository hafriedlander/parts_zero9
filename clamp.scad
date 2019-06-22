include <../hfscad/utils.scad>;
include <../hfscad/shapes.scad>;

$fn=60;

stem=[34.5,62];
clampZ=5;

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
                cylinder(d=stem.x + 3*2, h=clampZ, center=true);
                tY(stem.y - stem.x) cylinder(d=stem.x + 3*2, h=clampZ, center=true);
            }   
            epsilon(Z) stem();
        }

        tY(-stem.x/2) linear_extrude(clampZ, center=true) roundedSquare(4, center=true, r=1);
    }

    symmetricX() tX(stem.x/2 + 9/2) cube([9, 6, clampZ], center=true);
}

module loopWithBoltHoles() {
    difference() {
        loop();
        symmetricX() tX(stem.x/2 + 6) r(90*X) cylinder(d=3.2, h=10, center=true);
    }
}

intersection() {
    loopWithBoltHoles();
    tY(25) cube([70, 50, 20], center=true);
}

tY(-1) intersection() {
    loopWithBoltHoles();
    tY(-25) cube([70, 50, 20], center=true);
}
