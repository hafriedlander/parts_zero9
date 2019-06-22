
include <../hfscad/utils.scad>;
include <../hfscad/shapes.scad>;
include <../hfscad/thirdparty/threads.scad>;
include <../hfscad/thirdparty/knurledFinishLib_v2.scad>;

$fn=60;

difference() {
    union() {
        knurl(k_cyl_od=20, k_cyl_hg=10);
    }
    tZ(-0.01) metric_thread(diameter=16.15, pitch=1, length=7, internal=true);
}

