include <../hfscad/utils.scad>;
include <../hfscad/shapes.scad>;

$fn=60;
lZ=0.162;
h=lZ*6;


module mainRing() {
    difference() {
        cylinder(d=24, h=h);
        epsilon(Z) cylinder(d=16.1, h=h);
    }
}

module nodule(nh) {
    tY(16/2+4) difference() {
        hull() {
            //tZ(h/2) cube([6, 6, h], center=true);
            tY(-12) cylinder(d=24,h=nh);
            tY(3) cylinder(d=8,h=nh);
        }
        tY(3.7) tZ(-2)  cylinder(d=3, h=10);
        tY(-12) cylinder(d=16, h=10);
        t([0, -25-10]) cube([50, 50, 10], center=true);
    }
}

module bottomRing() {
    difference() {
        mainRing();
        tY(-10+12)epsilon(Z) cube([0.4, 10, h]);
    }
    difference() {
        nodule(nh=h);
        tY(-20+12+0.4) epsilon(Z) cube([20, 20, h]);
    }
}

module topRing() {    
    tZ(h) difference() {
        nodule(nh=h*2);
        // Cut out below ring on wrong side
        tX(0.4) tY(-2) flipX() tY(-20+12+0.4) epsilon(Z) cube([20, 20, h*4]);
        // Remove middle bit of nodule
        cylinder(d=21,h=h*2);
        // XY plane gap to seperate form nodule below
        t([-30+0.4, 0, 0]) cube([30,30,lZ]);
        difference() {
           t([-15, 0, 0]) cube([30,30,lZ]);
           epsilon(Z) cylinder(d=24,h=lZ);
        }
    }
}

bottomRing();
topRing();


module main() {
    symmetricZ() difference() {
        cylinder(d=24, h=h);
        epsilon(Z) cylinder(d=16.1, h=h);
        tY(16/2+(24-16)/4) cube([0.4, 10, 10], center=true);
    }

    *difference() {
        tZ(h) cylinder(d=24, h=h*2);
        epsilon(Z) tZ(h) cylinder(d=21, h=h*2);
    }

    difference() {
        noduleBlob();
        t([-5 + 0.4/2, 24/2-5 + 0.4, 0]) cube([10, 10, h*2+_e], center=true);
        tY(15) tZ(-2)  cylinder(d=3, h=10);
    }
}

*difference() {
    main();
    tY(10 + 12) tZ(h + lZ/2) cube([6+1, 20, lZ], center=true);
    tX(3) tY(10) tZ(h + lZ/2) cube([6, 20, lZ], center=true);
}
