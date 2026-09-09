// ============================================================
//  ZK-4KX Buck-Boost Converter Project Box  –  base library
//
//  Parameters and modules shared by the shell and back plate.
//  This file produces NO geometry on its own — include it from
//  a wrapper file and call shell() or back_plate().
//
//  Key dimensions:
//    cutout_l × cutout_w  = panel cutout for the ZK-4KX module
//    module_depth         = interior depth (module + wiring clearance)
//    wall                 = wall thickness throughout
// ============================================================

$fn = 64;

// ── Parameters ───────────────────────────────────────────────

// Panel cutout for the ZK-4KX module
cutout_l      = 71.3;   // cutout length (X)
cutout_w      = 39.3;   // cutout width  (Y)
cutout_r      = 1.5;    // corner radius on the cutout

// Box geometry
wall          = 3.0;    // wall thickness
module_depth  = 48.0;   // interior depth – module + wiring clearance
margin        = 8.0;    // extra margin around the cutout on all sides

// Derived outer dimensions
box_l         = cutout_l + 2 * margin;   // ~87.3 mm
box_w         = cutout_w + 2 * margin;   // ~55.3 mm
box_h         = module_depth + wall;     // front wall + interior depth

// Inner cavity dimensions
inner_l       = box_l - 2 * wall;
inner_w       = box_w - 2 * wall;

// Back plate fit
plate_clear   = 0.3;                     // radial clearance on each side
plate_l       = inner_l - 2 * plate_clear;
plate_w       = inner_w - 2 * plate_clear;
plate_h       = wall;                    // back plate thickness = 1 wall

// Inner ledge the back plate rests against
ledge_h       = 3.0;    // how tall the ledge is (along Z)
ledge_d       = 2.0;    // how far it protrudes inward from the inner wall

// M3 screw bosses in shell corners / screw holes in back plate
boss_r        = 4.0;    // outer radius of boss cylinder
boss_inset    = boss_r + 1.0;  // distance from inner corner to boss centre
m3_shaft_d    = 3.2;    // M3 clearance through back plate
m3_insert_d   = 4.2;    // M3 heat-set insert hole in boss (4.2 mm for M3)
m3_insert_h   = 4.0;    // depth of insert hole

// Vent holes on back plate
vent_d         = 4.0;
vent_rows      = 3;
vent_cols      = 5;
vent_margin_x  = boss_inset + vent_d;
vent_margin_y  = boss_inset + vent_d;
vent_spacing_x = (plate_l - 2 * vent_margin_x) / (vent_cols - 1);
vent_spacing_y = (plate_w - 2 * vent_margin_y) / (vent_rows - 1);
vent_x0        = -(vent_cols - 1) * vent_spacing_x / 2;
vent_y0        = -(vent_rows - 1) * vent_spacing_y / 2;

// Boss positions (at the four inner corners of the back opening)
boss_cx        = inner_l / 2 - boss_inset;
boss_cy        = inner_w / 2 - boss_inset;
boss_positions = [
    [ boss_cx,  boss_cy],
    [-boss_cx,  boss_cy],
    [ boss_cx, -boss_cy],
    [-boss_cx, -boss_cy]
];

// ── Helper ───────────────────────────────────────────────────

// Rounded-corner rectangle (extruded in Z), centred on XY
module rounded_rect(l, w, h, r) {
    hull() {
        for (xs = [-(l/2 - r), (l/2 - r)])
            for (ys = [-(w/2 - r), (w/2 - r)])
                translate([xs, ys, 0])
                    cylinder(h = h, r = r);
    }
}

// ── Part 1: Shell ─────────────────────────────────────────────
//
//   Z = 0     → front face outer surface (print face down)
//   Z = wall  → inner face / cavity starts
//   Z = box_h → back opening rim
//
module shell() {
    difference() {
        rounded_rect(box_l, box_w, box_h, 3.0);

        // Interior cavity – full depth, open at back
        translate([0, 0, wall])
            rounded_rect(inner_l, inner_w, module_depth + 0.1, 2.0);

        // Panel cutout on front face
        translate([0, 0, -0.1])
            rounded_rect(cutout_l, cutout_w, wall + 0.2, cutout_r);

        // M3 insert holes in bosses (drilled from the back)
        for (p = boss_positions)
            translate([p[0], p[1], box_h - m3_insert_h])
                cylinder(h = m3_insert_h + 0.1, d = m3_insert_d);
    }

    // Inner ledge – plate rests on this, flush with back rim
    ledge_z = box_h - plate_h - ledge_h;
    translate([0, 0, ledge_z])
        difference() {
            rounded_rect(inner_l, inner_w, ledge_h, 2.0);
            translate([0, 0, -0.1])
                rounded_rect(inner_l - 2 * ledge_d, inner_w - 2 * ledge_d,
                             ledge_h + 0.2, 1.5);
        }

    // Screw bosses at back corners
    for (p = boss_positions)
        translate([p[0], p[1], wall])
            cylinder(h = module_depth - plate_h, r = boss_r);
}

// ── Part 2: Back plate ────────────────────────────────────────
//
//   Z = 0       → inner face (faces into box interior)
//   Z = plate_h → outer face (flush with back rim of shell)
//
module back_plate() {
    difference() {
        rounded_rect(plate_l, plate_w, plate_h, 1.5);

        // Vent holes
        for (col = [0 : vent_cols - 1])
            for (row = [0 : vent_rows - 1])
                translate([
                    vent_x0 + col * vent_spacing_x,
                    vent_y0 + row * vent_spacing_y,
                    -0.1
                ])
                    cylinder(h = plate_h + 0.2, d = vent_d);

        // M3 clearance holes at corners
        for (p = boss_positions)
            translate([p[0], p[1], -0.1])
                cylinder(h = plate_h + 0.2, d = m3_shaft_d);
    }
}
