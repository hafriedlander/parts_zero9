
include <../hfscad/utils.scad>;
include <../hfscad/shapes.scad>;
include <../hfscad/thirdparty/threads.scad>;
include <../hfscad/thirdparty/knurledFinishLib_v2.scad>;

$fn=20;
lZ=0.162;
lW=0.4;
gap=lW*4;

module base() {
    tZ(-10) difference() {
        union() {
            knurl(k_cyl_od=20, k_cyl_hg=10);
        }
        tZ(-0.01) metric_thread(diameter=16, pitch=1, length=7, internal=true);
    }
}

module hoop() {
    difference() {
        minkowski() {
            union() {
                cylinder(d1=15,d2=0,h=15/2);
                cylinder(d=9.5,h=15/2 + 0.5);
            }
            sphere(d=1);
        }

        tZ(15/2-1.8) r(90*X) cylinder(d=3,h=20, center=true);
    }
}

tZ(-1) hoop();

module hoopHole() {
    cylinder(d1=15+1+gap, d2=0, h=15/2 + 0.5 + gap/2);
    tZ(-lZ*2 - 0.5) cylinder(d=15+1+gap, h=0.5 + lZ*2);
}

difference() {
    union() {
       base();
       cylinder(d=18.5,h=1.5);
    }
    tZ(-1) hoopHole();
}