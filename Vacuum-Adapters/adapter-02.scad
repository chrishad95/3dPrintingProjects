// ============================================================
//  Vacuum Adapter 02
//  Couples two tubes with the same outer diameter
//    Both tubes: outer diameter = 41.0 mm
//
//  Design: two sockets separated by an internal stop ring.
//    Each tube slides in 32 mm from its respective end until
//    it hits the centre ring.
//
//  Overall length: 32 + 32 = 64 mm
//  Wall thickness: 3.0 mm
//
//  Print orientation: stand upright on either end – no supports needed.
// ============================================================

$fn = 128;

// ── Parameters ───────────────────────────────────────────────

wall          = 3.0;      // socket wall thickness

// Tube OD and fit
tube_od       = 40.8;
socket_clear  = 0.3;                         // radial clearance
socket_id     = tube_od + 2 * socket_clear;  // ~41.4 mm – tube slides in
socket_od     = socket_id + 2 * wall;        // ~47.4 mm

// Each tube slides in 32 mm
socket_len    = 32.0;
total_length  = socket_len * 2;              // 64 mm

// Internal stop ring at the centre
// Inner dia smaller than tube OD so tubes butt against it,
// but large enough to leave airflow passage
stop_id       = socket_id - 4.0;  // ~37.4 mm
stop_h        = 2.0;              // axial height of the ring

// ── Assembly ─────────────────────────────────────────────────
//
//   Built as a single difference() so the bore is continuous.
//
//   Z = 0             → open mouth of socket A
//   Z = socket_len    → centre / stop ring
//   Z = total_length  → open mouth of socket B
//
difference() {
    // ── Outer shell ──────────────────────────────────────────
    cylinder(h = total_length, d = socket_od);

    // ── Continuous bore ──────────────────────────────────────
    translate([0, 0, -0.1])
        cylinder(h = total_length + 0.2, d = socket_id);
}

// ── Stop ring (added after difference so bore stays open) ────
// Thin annular ring at the centre; inner dia = stop_id
translate([0, 0, socket_len - stop_h / 2])
    difference() {
        cylinder(h = stop_h, d = socket_id);
        translate([0, 0, -0.1])
            cylinder(h = stop_h + 0.2, d = stop_id);
    }
