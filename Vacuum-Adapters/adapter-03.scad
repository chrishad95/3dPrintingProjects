// ============================================================
//  Vacuum Adapter 03
//  Connects a vacuum attachment to a tube:
//    End A (deep socket)   – attachment slides IN
//                            attachment outer diameter = 40.0 mm
//                            insertion depth = 55 mm
//    End B (shallow socket) – adapter slides OVER tube
//                            tube outer diameter = 41.0 mm
//                            insertion depth = 30 mm
//
//  Overall length: 55 + 30 = 85 mm
//  Wall thickness: 3.0 mm
//
//  A small internal stop ridge separates the two sockets so
//  neither piece can push through to the other side.
//
//  Print orientation: stand upright on either end – no supports needed.
// ============================================================

$fn = 128;

// ── Parameters ───────────────────────────────────────────────

wall          = 3.0;      // wall thickness throughout

// End A – deep socket, attachment (OD = 40 mm) slides in
attach_od     = 40.0;
socket_a_clear = 0.3;                             // radial clearance
socket_a_id   = attach_od + 2 * socket_a_clear;  // ~40.6 mm
socket_a_od   = socket_a_id + 2 * wall;          // ~46.6 mm
socket_a_len  = 55.0;                             // insertion depth

// End B – shallow socket, slides over tube (OD = 41 mm)
tube_od       = 41.0;
socket_b_clear = 0.3;                             // radial clearance
socket_b_id   = tube_od + 2 * socket_b_clear;    // ~41.6 mm
socket_b_od   = socket_b_id + 2 * wall;          // ~47.6 mm
socket_b_len  = 30.0;                             // insertion depth

total_length  = socket_a_len + socket_b_len;      // 85 mm

// Internal stop ridge at the junction
ridge_h       = 3.0;
ridge_id      = socket_a_id - 6.0;   // ~34.6 mm – narrower than both tube ODs

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
//   Z = 0             → open mouth of socket A (attachment end)
//   Z = socket_a_len  → junction / stop ridge
//   Z = total_length  → open mouth of socket B (tube end)
//
union() {
    // ── End A: deep socket for attachment ────────────────────
    tube_cyl(socket_a_len, socket_a_od, socket_a_id);

    // ── End B: shallow socket for tube ───────────────────────
    translate([0, 0, socket_a_len])
        tube_cyl(socket_b_len, socket_b_od, socket_b_id);

    // ── Transition ring where the two ODs meet ────────────────
    // Fill any step between socket_a_od and socket_b_od with a short taper
    translate([0, 0, socket_a_len - 2])
        cylinder(h = 4, d1 = socket_a_od, d2 = socket_b_od);

    // ── Internal stop ridge ───────────────────────────────────
    translate([0, 0, socket_a_len - ridge_h / 2])
        difference() {
            cylinder(h = ridge_h, d = min(socket_a_od, socket_b_od));
            translate([0, 0, -0.1])
                cylinder(h = ridge_h + 0.2, d = ridge_id);
        }
}
