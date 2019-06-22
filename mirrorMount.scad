
include <../hfscad/utils.scad>;
include <../hfscad/shapes.scad>;

$fn=50;

barD = 22;
clamp = [15, 115];
wall = 0.4 * 15;
mirrorID = 18.25;
mirrorOD = 23.5;

module bar() {
    r(90*Y) cylinder(d=barD, h=100, center=true);
}

module mount() {
    r(90*Y) difference() {
        cylinder(d=barD + wall*2, h=clamp.x, center=true);
        cylinder(d=barD, h=clamp.x + _e, center=true);
    }

    // Mirror side
    tY(wall/2) tZ(20/2 + barD/2) cube([clamp.x, wall, 20], center=true);
    tY(-wall/2 - 0.4*6) tZ(20/2 + barD/2) cube([clamp.x, wall, 20], center=true);
    //tY(wall/2) tZ(clamp.y/2 + barD/2) cube([clamp.x, wall, clamp.y], center=true);

    // Opposite side
    //tZ(-(20/2 + barD/2)) cube([clamp.x, wall*2, 10], center=true);

}


module corePin(_d=0, _h=0) {
    d=12 + _d;
    h=4 + _h;

    edgeD=6 + _d;
    edgeS=0.1;
    edgeX=6.7;

    r((90+37)*-X) r(90*Y)union() {
        /*symmetricZ() blend(10) between([
            tween("z", -h/2 - 5, -h/2),
            tween("d", edgeD, d),
            tween("s", edgeS, 1),
            tween("x", edgeX, 0)
        ]) {
            tZ(tval("z")) hull() {
                tX(tval("x")) scale([tval("s"), 1, 1]) cylinder(d=tval("d"), h=_e, center=true);
                tX(edgeX) scale([edgeS, 1, 1]) cylinder(d=edgeD, h=_e, center=true);
            }
        }*/

        hull() {
            cylinder(d=d, h=h, center=true);
            tX(edgeX) scale([edgeS, 1, 1]) cylinder(d=edgeD, h=h + 10, center=true);
        }
    }
}

module corePinCutout() {
    union() for (i = [0 : 5 : 70]) {
        r(i*X) corePin(0.4, 0.4);
    }
}

module splitMount() {
    pinZ = -barD/2-6;

    *union() {
        corePin();
        #corePinCutout();
    }

    difference() {
        mount();
        // Slit
        tZ(100/2) tY(-0.4*6*0.5) cube([clamp.x+_e, 0.4*6, 100], center=true);
        tZ(-100/2) tY(-0.4/2) cube([clamp.x+_e, 0.4, 100], center=true);

        // Bolt hole
        tZ(barD/2+12) r(90*X) cylinder(d=5, h=20, center=true);

        intersection() {
            tZ(pinZ) r(90*Y) cylinder(d=12.8, h=clamp.x+1, center=true);
            tZ(pinZ) tY(-20/2) cube([clamp.x+10, 20, 20], center=true);
        }

        intersection() {
            tZ(pinZ) corePinCutout();
            tZ(pinZ) tY(20/2) cube([clamp.x+10, 20, 20], center=true);
        }
    }

    difference() {
        tZ(pinZ) r(90*Y) cylinder(d=12, h=clamp.x, center=true);
        tZ(pinZ) corePinCutout();
    }

    difference() {
        tZ(pinZ) corePin();
        tZ(pinZ) r(90*Y) cylinder(d=8.8, h=clamp.x, center=true);
        r(90*Y) cylinder(d=barD, h=clamp.x, center=true);
    }


    tZ(pinZ) r(90*Y) cylinder(d=8, h=clamp.x, center=true);
}

module mirrorPin() {
    ang=30;
    xOffset=(clamp.x-mirrorOD)/2;

    tX(xOffset) r(ang*X) difference() {
        union() {
            cylinder(d=mirrorOD, h=wall);
            cylinder(d=mirrorID, h=wall*2);
        }
        tZ(-5) cylinder(d=5, h=25);
    }

    difference() {
        union() tZ(-(clamp.y - 20)) blend(30) between([
            tween("x", clamp.x, mirrorOD, "inQuad"),
            tween("y", wall, mirrorOD, "inQuad"),
            tween("pos", [0, wall/2, 0], [xOffset, 0, clamp.y - 20], ["inQuad", "linear", "linear"]),
            tween("r", 0, mirrorOD/2, "inQuad"),
            tween("a", 0, ang)
        ]) {
            t(tval("pos")) r(tval("a")*X) linear_extrude(_e) roundedSquare([tval("x"), tval("y")], r=tval("r"), center=true);
        }

        tX(xOffset) r(ang*X) tZ(0) cylinder(d=5, h=20);
    }
}

//color("grey") bar();
difference() {
    union() {
        splitMount();
        tZ(clamp.y + barD/2) mirrorPin();
    }

    // Hole for nut
    t([(clamp.x-mirrorOD)/2 + 1.2, 0, barD/2 + clamp.y]) r(30*X) tZ(3.75) r(90*-Z) t([0, -25+4, 0]) cube([8, 50, 4.5], center=true);
}
