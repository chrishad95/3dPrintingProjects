
$fn=64;
union () {
    
color("green")
cube([23,68,2],center=false);

translate([20.0,1,1])
rotate([0,0,90-63.5])
difference() {
color("red")
cube([2,22,40]);

color("blue")
rotate([0,90,0])
translate([-25,11,-1])
cylinder(h=5,r=3.1);
}
}
