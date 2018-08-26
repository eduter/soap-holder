module soapHolderParts(outerDiameter, innerDiameter, pinholeSize, clearance, fn) {
  ir = innerDiameter / 2;
  or = outerDiameter / 2;
  w = or - ir;
  h = sqrt(3) / 2 * w;
  FN = fn;

  rotate([0, 180, 0])
  difference() {
    top(ir, w, FN);
    union() {
      pin(pinholeSize, h + ir - pinholeSize);
      pin(pinholeSize, -(h + ir - pinholeSize));
    }
  }

  translate([outerDiameter * 1.1, 0, 0])
  difference() {
    bottom(ir, w, FN);
    union() {
      pin(pinholeSize, h + ir - pinholeSize);
      pin(pinholeSize, -(h + ir - pinholeSize));
    }
  }

  ps = pinholeSize - clearance;
  translate([-0.6 * outerDiameter, 0, ps / 2]) rotate([90, 0, 0]) pin(ps, 0);
  translate([-0.6 * outerDiameter - 2 * ps, 0, ps / 2]) rotate([90, 0, 0]) pin(ps, 0);

  diagonal = 2 * ir + sqrt(3) * (or - ir);
  echo("max soap diagonal (mm)", diagonal);
}

module top(ir, w, FN) {
  rotate_extrude(convexity = 10, $fn = FN)
    section(ir, w, FN);
}

module bottom(ir, w, FN) {
  s = 360/FN;
  rotate([270, 0, 0])
  for (a = [0:s:360-s]) {
    hull() {
      rotate([0, a, 0]) linear_extrude(height = 0.01) scale([1, f(a), 1]) section(ir, w, FN);
      rotate([0, a+s, 0]) linear_extrude(height = 0.01) scale([1, f(a+s), 1]) section(ir, w, FN);
    }
  }
}

// sinusoidal function varying between .5 and 1 3 times in 360 degrees
function f(x) = 0.25 * (sin(x*3) + 1) + 0.5;

module section(ir, w, FN) {
  h = sqrt(3) / 2 * w;
  rotate([0, 0, 270])
  translate([0, ir, 0])
    intersection() {
      circle(r = w, $fn = FN);
      translate([+w / 2, h, 0]) circle(r = w, $fn = FN);
      translate([-w / 2, h, 0]) circle(r = w, $fn = FN);
      square(w);
    }
}

module pin(size, x) {
  translate([x, 0, 0]) cube([size, size, size * 2], true);
}

soapHolderParts(outerDiameter = 100, innerDiameter = 20, pinholeSize = 5, clearance = 0.3, fn = 180);
