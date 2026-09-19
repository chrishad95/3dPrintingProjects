// ============================================================
//  Shop Vac Vacuum Adapter
//  Connects a vacuum attachment to a Shop-Vac tube:
//    End A (attachment socket) – attachment slides IN
//                               attachment outer diameter = ~39.8 mm
//                               insertion depth = 60 mm
//    Transition Section        – smooth reduction cone (15 mm)
//    End B (tapered socket)    – slides OVER tapered Shop-Vac tube
//                               tube outer diameter = 56.7 mm (tip) to 58.4 mm (base)
//                               insertion depth = 36 mm
//
//  Wall thickness: 3.0 mm
//  Print orientation: stand upright on End A – no supports needed.
// ============================================================

$fn = 128;

// ── Parameters ───────────────────────────────────────────────

wall           = 3.0;     // wall thickness throughout

// End A – deep socket, attachment (OD = 39.8 mm) slides in
attach_od      = 39.8;
socket_a_clear = 0.3;                              // radial clearance
socket_a_id    = attach_od + 2 * socket_a_clear;  // ~40.4 mm
socket_a_od    = socket_a_id + 2 * wall;           // ~46.4 mm
socket_a_len   = 60.0;                             // insertion depth

// Transition section between Socket A and Socket B
trans_len      = 15.0;                             // smooth reduction cone length

// End B – tapered socket, slides over tapered Shop-Vac tube
// Tube OD is ~56.7 mm at the tip and expands to ~58.4 mm further up
tube_od_tip    = 56.7;                             // tube OD at the insertion tip (bottom of socket B / stop)
tube_od_base   = 58.4;                             // tube OD at mouth (outer opening of socket B)
socket_b_clear = 0.3;                              // radial clearance
socket_b_id1   = tube_od_tip + 2 * socket_b_clear; // ~57.3 mm at junction / stop
socket_b_id2   = tube_od_base + 2 * socket_b_clear;// ~59.0 mm at outer mouth
socket_b_od1   = socket_b_id1 + 2 * wall;          // ~63.3 mm
socket_b_od2   = socket_b_id2 + 2 * wall;          // ~65.0 mm
socket_b_len   = 36.0;                             // insertion depth

total_length   = socket_a_len + trans_len + socket_b_len;

// Internal stop ring: a narrow ledge sitting at the base of socket B
stop_id        = socket_a_id - 4.0;                // ~36.4 mm (airflow passage)
stop_h         = 2.0;                              // axial height of the ledge

// ── Assembly ─────────────────────────────────────────────────
//
//   Z = 0                                       → mouth of Socket A (attachment entrance)
//   Z = socket_a_len                            → end of Socket A / start of transition
//   Z = socket_a_len + trans_len                → end of transition / junction with Socket B (stop ring)
//   Z = socket_a_len + trans_len + socket_b_len → mouth of Socket B (Shop-Vac tube entrance)
//
difference() {
    // ── Outer shell ──────────────────────────────────────────
    union() {
        // End A outer cylinder
        cylinder(h = socket_a_len, d = socket_a_od);

        // Smooth conical transition between sockets
        translate([0, 0, socket_a_len])
            cylinder(h = trans_len, d1 = socket_a_od, d2 = socket_b_od1);

        // End B tapered outer cylinder matching inner taper wall thickness
        translate([0, 0, socket_a_len + trans_len])
            cylinder(h = socket_b_len, d1 = socket_b_od1, d2 = socket_b_od2);
    }

    // ── Continuous bore ──────────────────────────────────────
    // End A bore
    translate([0, 0, -0.1])
        cylinder(h = socket_a_len + 0.1, d = socket_a_id);

    // Transition bore (funnel from socket_a_id to socket_b_id1)
    translate([0, 0, socket_a_len - 0.05])
        cylinder(h = trans_len + 0.1, d1 = socket_a_id, d2 = socket_b_id1);

    // End B tapered bore (narrow at stop junction, wider at open mouth)
    translate([0, 0, socket_a_len + trans_len - 0.05])
        cylinder(h = socket_b_len + 0.2, d1 = socket_b_id1, d2 = socket_b_id2);
}

// ── Stop ring ─────────────────────────────────────────────────
// Positioned at the junction where Socket B begins
translate([0, 0, socket_a_len + trans_len - stop_h / 2])
    difference() {
        cylinder(h = stop_h, d = socket_b_id1);
        translate([0, 0, -0.1])
            cylinder(h = stop_h + 0.2, d = stop_id);
    }
