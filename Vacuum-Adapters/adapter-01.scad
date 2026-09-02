// ============================================================
//  Vacuum Adapter 01
//  Connects two tubes:
//    End A (spigot / male)  – slides INTO tube 1
//                             tube 1 inner diameter = 34.0 mm
//    End B (socket / female) – tube 2 slides INTO this end
//                             tube 2 outer diameter = 37.8 mm
//
//  Overall length: ~76.2 mm (3 inches)
//  Wall thickness: 3.0 mm
//
//  Print orientation: stand upright on either end – no supports needed.
// ============================================================

$fn = 128;

// ── Parameters ───────────────────────────────────────────────

total_length   = 76.2;    // 3 inches in mm
wall           = 3.0;     // wall thickness throughout

// End A – spigot that slides inside tube 1 (tube 1 ID = 34 mm)
spigot_clear   = 0.3;                        // radial clearance
spigot_od      = 34.0 - 2 * spigot_clear;   // ~33.4 mm  (fits inside tube 1)
spigot_id      = spigot_od - 2 * wall;       // ~27.4 mm  (air passage)
spigot_len     = 25.0;                       // how far the spigot inserts

// End B – socket that tube 2 slides into (tube 2 OD = 37.8 mm)
socket_clear   = 0.3;                        // radial clearance
socket_id      = 37.8 + 2 * socket_clear;   // ~38.4 mm  (tube 2 slides in)
socket_od      = socket_id + 2 * wall;       // ~44.4 mm
socket_len     = 25.0;                       // how deep the socket receives

// Middle transition section length (fills remaining length)
mid_len        = total_length - spigot_len - socket_len;  // ~26.2 mm

// ── Helper: hollow cylinder ───────────────────────────────────
module tube(length, od, id) {
    difference() {
        cylinder(h = length, d = od);
        translate([0, 0, -0.1])
            cylinder(h = length + 0.2, d = id);
    }
}

// ── Assembly (built along +Z) ─────────────────────────────────
//
//   Z = 0                  → bottom of spigot (End A)
//   Z = spigot_len         → shoulder / start of transition
//   Z = spigot_len+mid_len → start of socket collar (End B)
//   Z = total_length       → open mouth of socket
//
union() {

    // ── End A: spigot ─────────────────────────────────────────
    tube(spigot_len, spigot_od, spigot_id);

    // ── Transition: tapers from spigot OD→socket OD on outside,
    //               spigot ID→socket ID on inside
    translate([0, 0, spigot_len])
        difference() {
            cylinder(h = mid_len, d1 = spigot_od, d2 = socket_od);
            translate([0, 0, -0.1])
                cylinder(h = mid_len + 0.2, d1 = spigot_id, d2 = socket_id);
        }

    // ── End B: socket collar ─────────────────────────────────
    translate([0, 0, spigot_len + mid_len])
        tube(socket_len, socket_od, socket_id);
}
