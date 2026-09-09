// ============================================================
//  ZK-4KX Buck-Boost Converter Project Box
//
//  The ZK-4KX module panel-mounts through a rectangular cutout.
//  This box provides:
//    • A front face with the panel cutout the module clicks into
//    • A box body deep enough to house the module behind the panel
//    • Vent holes on the back face for airflow/heat dissipation
//    • A flat bottom so it can sit on a surface or be wall-mounted
//
//  Key dimensions (all adjustable at the top):
//    cutout_l × cutout_w  = panel cutout for the module
//    module_depth         = how far the module extends behind the panel
//    wall                 = box wall thickness
//
//  Print orientation: front face DOWN – flat face on the build plate,
//  box body printing upward. No supports needed.
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
box_l         = cutout_l + 2 * margin;           // ~87.3 mm
box_w         = cutout_w + 2 * margin;           // ~55.3 mm
box_h         = module_depth + wall;             // ~38 mm  (wall = front face)

// Vent holes on back face
vent_d         = 4.0;   // diameter of each vent hole
vent_rows      = 3;     // rows of vents
vent_cols      = 6;     // columns of vents
vent_spacing_x = (box_l - 2 * margin) / (vent_cols - 1);   // spacing along X
vent_spacing_y = (box_w - 2 * margin) / (vent_rows - 1);   // spacing along Y
vent_x0        = -(vent_cols - 1) * vent_spacing_x / 2;    // X start (centred)
vent_y0        = -(vent_rows - 1) * vent_spacing_y / 2;    // Y start (centred)

// ── Modules ──────────────────────────────────────────────────

// Rounded-corner rectangle (extruded in Z)
module rounded_rect(l, w, h, r) {
    hull() {
        for (xs = [-(l/2 - r), (l/2 - r)])
            for (ys = [-(w/2 - r), (w/2 - r)])
                translate([xs, ys, 0])
                    cylinder(h = h, r = r);
    }
}

// ── Assembly ─────────────────────────────────────────────────
//
//   Coordinate origin: centre of the front face (Z = 0)
//   Z = 0           → front face outer surface
//   Z = wall        → front face inner surface / start of interior
//   Z = box_h       → back face outer surface
//
difference() {
    // ── Outer shell ──────────────────────────────────────────
    translate([0, 0, 0])
        rounded_rect(box_l, box_w, box_h, 3.0);

    // ── Interior cavity ───────────────────────────────────────
    // Starts at Z=wall (inner face of front panel).
    // Height = module_depth - wall so cavity ends at Z=module_depth,
    // leaving the last `wall` mm as the solid back face.
    translate([0, 0, wall])
        rounded_rect(box_l - 2*wall, box_w - 2*wall, module_depth - wall, 2.0);

    // ── Panel cutout on front face ───────────────────────────
    translate([0, 0, -0.1])
        rounded_rect(cutout_l, cutout_w, wall + 0.2, cutout_r);

    // ── Vent holes on back face ───────────────────────────────
    for (col = [0 : vent_cols - 1])
        for (row = [0 : vent_rows - 1])
            translate([
                vent_x0 + col * vent_spacing_x,
                vent_y0 + row * vent_spacing_y,
                box_h - wall - 0.1
            ])
                cylinder(h = wall + 0.2, d = vent_d);
}
