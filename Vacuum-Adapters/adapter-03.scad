// ============================================================
//  Vacuum Adapter 03
//  Connects a vacuum attachment to a tube:
//    End A (deep socket)    – attachment slides IN
//                             attachment outer diameter = 40.0 mm
//                             insertion depth = 55 mm
//    End B (shallow socket) – adapter slides OVER tube
//                             tube outer diameter = 41.0 mm
//                             insertion depth = 30 mm
//
//  Overall length: 55 + 30 = 85 mm
//  Wall thickness: 3.0 mm
//
//  A small internal stop ring at the junction prevents either
//  piece pushing fully through, while leaving the bore open.
//
//  Print orientation: stand upright on either end – no supports needed.
// ============================================================

$fn = 128;

// ── Parameters ───────────────────────────────────────────────

wall           = 3.0;     // wall thickness throughout

// End A – deep socket, attachment (OD = 40 mm) slides in
attach_od      = 39.8;
socket_a_clear = 0.3;                              // radial clearance
socket_a_id    = attach_od + 2 * socket_a_clear;  // ~40.6 mm
socket_a_od    = socket_a_id + 2 * wall;           // ~46.6 mm
socket_a_len   = 60.0;                             // insertion depth

// End B – shallow socket, slides over tube (OD = 41 mm)
tube_od        = 40.6;
socket_b_clear = 0.3;                              // radial clearance
socket_b_id    = tube_od + 2 * socket_b_clear;    // ~41.6 mm
socket_b_od    = socket_b_id + 2 * wall;           // ~47.6 mm
socket_b_len   = 32.0;                             // insertion depth

total_length   = socket_a_len + socket_b_len;      // 85 mm

// Internal stop ring: a narrow ledge sitting at the junction.
// Its inner diameter is smaller than both tube ODs so the tubes
// butt against it, but large enough not to restrict airflow much.
// We use the smaller of the two socket IDs minus a small step.
stop_id        = socket_a_id - 4.0;  // ~36.6 mm  (well clear of the bore)
stop_h         = 2.0;                // axial height of the ledge

// ── Assembly ─────────────────────────────────────────────────
//
//   Built as one difference() so the bore is continuous throughout.
//
//   Outer shell:
//     Z = 0 … socket_a_len          → cylinder at socket_a_od
//     Z = socket_a_len … total_len  → cylinder at socket_b_od
//     (short taper blends the OD step at the junction)
//
//   Subtracted bore:
//     Z = 0 … socket_a_len          → socket_a_id
//     Z = socket_a_len … total_len  → socket_b_id
//
//   Stop ring added back inside via a small annular solid at
//   the junction (inner dia = stop_id, outer = socket_a_id).
//
difference() {
    // ── Outer shell ──────────────────────────────────────────
    union() {
        // End A outer cylinder
        cylinder(h = socket_a_len, d = socket_a_od);

        // End B outer cylinder
        translate([0, 0, socket_a_len])
            cylinder(h = socket_b_len, d = socket_b_od);

        // Short taper to blend the OD step (purely cosmetic)
        translate([0, 0, socket_a_len - 1])
            cylinder(h = 2, d1 = socket_a_od, d2 = socket_b_od);
    }

    // ── Continuous bore ──────────────────────────────────────
    // End A bore (full length of socket A, plus overlap into B)
    translate([0, 0, -0.1])
        cylinder(h = socket_a_len + 0.1, d = socket_a_id);

    // End B bore (full length of socket B, plus overlap into A)
    translate([0, 0, socket_a_len - 0.1])
        cylinder(h = socket_b_len + 0.2, d = socket_b_id);
}

// ── Stop ring (added after the difference so bore stays open) ─
// A thin annular ring at the junction, inside the bore,
// inner dia = stop_id, outer dia = socket_a_id (sits flush with bore wall)
translate([0, 0, socket_a_len - stop_h / 2])
    difference() {
        cylinder(h = stop_h, d = socket_a_id);
        translate([0, 0, -0.1])
            cylinder(h = stop_h + 0.2, d = stop_id);
    }
