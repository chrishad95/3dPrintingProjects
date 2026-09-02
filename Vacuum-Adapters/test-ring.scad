// ============================================================
//  Test Ring
//  Use to verify fit before printing a full adapter.
//
//  Inner diameter : 57.7 mm
//  Wall thickness : 3.0 mm  →  outer diameter = 63.7 mm
//  Height         : 5.0 mm
// ============================================================

$fn = 128;

// ── Parameters ───────────────────────────────────────────────
ring_id = 57.7;
wall    = 3.0;
ring_od = ring_id + 2 * wall;  // 63.7 mm
height  = 5.0;

// ── Ring ─────────────────────────────────────────────────────
difference() {
    cylinder(h = height, d = ring_od);
    translate([0, 0, -0.1])
        cylinder(h = height + 0.2, d = ring_id);
}
