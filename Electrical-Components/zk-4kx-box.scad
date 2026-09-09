// ============================================================
//  ZK-4KX Buck-Boost Converter Project Box  –  v2
//
//  Two-part design:
//    Part 1: Shell  – front face with panel cutout, open back,
//                     inner ledge near the back the plate rests on,
//                     M3 screw bosses at the four back corners.
//    Part 2: Back plate – flush-fitting removable back with vent
//                         holes and M3 screw holes.
//
//  Render control (set at bottom of file):
//    render_part = "shell"      – shell only
//    render_part = "back"       – back plate only (offset for printing)
//    render_part = "both"       – both parts in assembly position
//
//  Key dimensions (all adjustable at the top):
//    cutout_l × cutout_w  = panel cutout for the module
//    module_depth         = interior depth (module + wiring clearance)
//    wall                 = box wall thickness
//
//  Print orientation:
//    Shell      : front face DOWN – no supports needed
//    Back plate : flat face DOWN  – no supports needed
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
// Usable area avoids the corner screw holes (boss_inset radius + vent_d/2 gap)
vent_d         = 4.0;
vent_rows      = 3;
vent_cols      = 5;
vent_margin_x  = boss_inset + vent_d;   // keep vents clear of corner bosses
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

// ── Helper modules ───────────────────────────────────────────

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
//   Z = 0         → front face outer surface (print face down here)
//   Z = wall      → front face inner / cavity starts
//   Z = box_h     → back opening rim
//
module shell() {
    difference() {
        // Outer body
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

    // Inner ledge – ring of material around the cavity perimeter,
    // sitting at Z = (box_h - plate_h - ledge_h) so the back plate
    // rests on it flush with the back rim.
    ledge_z = box_h - plate_h - ledge_h;
    translate([0, 0, ledge_z])
        difference() {
            // Ledge solid (inner wall footprint)
            rounded_rect(inner_l, inner_w, ledge_h, 2.0);
            // Subtract the plate opening (plate dims + clearance already)
            translate([0, 0, -0.1])
                rounded_rect(inner_l - 2 * ledge_d, inner_w - 2 * ledge_d,
                             ledge_h + 0.2, 1.5);
        }

    // Screw bosses at back corners (added inside the cavity)
    for (p = boss_positions)
        translate([p[0], p[1], wall])
            cylinder(h = module_depth - plate_h, r = boss_r);
}

// ── Part 2: Back plate ────────────────────────────────────────
//
//   Flat panel, plate_l × plate_w, plate_h thick.
//   Z = 0 → inner face (faces into box interior)
//   Z = plate_h → outer face (flush with back rim of shell)
//
module back_plate() {
    difference() {
        // Plate body
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

// ── Render control ────────────────────────────────────────────
//   Change this value to switch what is rendered / exported.
//   "shell"  → shell only  (print front-face down)
//   "back"   → back plate only  (print either face down)
//   "both"   → assembly view
render_part = "both";

if (render_part == "shell") {
    shell();
} else if (render_part == "back") {
    back_plate();
} else {
    // Assembly view: shell in place, back plate shown exploded slightly
    shell();
    translate([0, 0, box_h + 5])
        back_plate();
}
