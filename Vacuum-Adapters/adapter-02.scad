// ============================================================
//  Vacuum Adapter 02
//  Couples two tubes with the same outer diameter
//    Both tubes: outer diameter = 41.0 mm
//
//  Design: two sockets separated by an internal stop ridge.
//    Each tube slides in from its respective end until it
//    hits the centre ridge.
//
//  Overall length: ~50.8 mm (2 inches)
//  Wall thickness: 3.0 mm
//
//  Print orientation: stand upright on either end – no supports needed.
// ============================================================

$fn = 128;

// ── Parameters ───────────────────────────────────────────────

total_length  = 50.8;     // 2 inches in mm
wall          = 3.0;      // socket wall thickness

// Tube OD and fit
tube_od       = 41.0;
socket_clear  = 0.3;                        // radial clearance
socket_id     = tube_od + 2 * socket_clear; // ~41.6 mm – tube slides in
socket_od     = socket_id + 2 * wall;       // ~47.6 mm

// Each socket occupies half the total length
socket_len    = total_length / 2;           // 25.4 mm each side

// Internal stop ridge at the centre
ridge_h       = 3.0;    // height (thickness) of the ridge along Z
ridge_id      = socket_id - 6.0;  // ~35.6 mm – narrower than the tube OD so tubes butt up against it

// ── Helper: hollow cylinder ───────────────────────────────────
module tube_cyl(length, od, id) {
    difference() {
        cylinder(h = length, d = od);
        translate([0, 0, -0.1])
            cylinder(h = length + 0.2, d = id);
    }
}

// ── Assembly ─────────────────────────────────────────────────
//
//   Z = 0              → open mouth of socket A
//   Z = socket_len     → centre / stop ridge
//   Z = total_length   → open mouth of socket B
//
union() {
    // ── Socket A (bottom half) ────────────────────────────────
    tube_cyl(socket_len, socket_od, socket_id);

    // ── Socket B (top half) ───────────────────────────────────
    translate([0, 0, socket_len])
        tube_cyl(socket_len, socket_od, socket_id);

    // ── Internal stop ridge at centre ────────────────────────
    translate([0, 0, socket_len - ridge_h / 2])
        difference() {
            cylinder(h = ridge_h, d = socket_od);
            translate([0, 0, -0.1])
                cylinder(h = ridge_h + 0.2, d = ridge_id);
        }
}
