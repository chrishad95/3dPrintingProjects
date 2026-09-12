// ============================================================
//  3/4 Cup Measuring Cup
//
//  US cup = 236.588 mL
//  3/4 cup = 177.441 mL = 177,441 mm³
//
//  A straight-sided cylindrical cup with:
//    • A fill-line groove at the 3/4-cup level
//    • A raised "3/4 CUP" label on the outer wall
//    • A flat tab handle
//
//  Print orientation: upright (open end UP) – no supports needed.
// ============================================================

$fn = 96;

// ── Parameters ───────────────────────────────────────────────

target_vol_mm3 = 177441;    // 177.441 mL converted to mm³ (1 mL = 1000 mm³)

inner_r        = 39.0;      // inner radius (mm) – sets cup diameter
wall           = 2.5;       // wall thickness
bottom_h       = 3.0;       // bottom thickness
extra_h        = 10.0;      // headroom above fill line

// Derived
inner_h   = target_vol_mm3 / (PI * inner_r * inner_r);  // ~37.2 mm
outer_r   = inner_r + wall;
outer_h   = bottom_h + inner_h + extra_h;

// Fill-line groove
groove_depth  = 0.8;   // how deep the groove cuts into the wall
groove_height = 1.2;   // groove slot height

// Handle (flat rectangular tab, centred at mid-height of cup)
handle_w      = 12.0;   // handle width (Z direction on cup)
handle_l      = 50.0;   // how far handle extends from cup wall
handle_thick  = 6.0;    // handle thickness
handle_hole_w = 6.0;    // finger hole width
handle_hole_h = 28.0;   // finger hole height

// ── Cup body ─────────────────────────────────────────────────
difference() {
    // Outer cylinder
    cylinder(h = outer_h, r = outer_r);

    // Inner cavity
    translate([0, 0, bottom_h])
        cylinder(h = outer_h, r = inner_r);

    // Fill-line groove on inner wall at the 3/4-cup level
    translate([0, 0, bottom_h + inner_h - groove_height / 2])
        difference() {
            cylinder(h = groove_height, r = inner_r + 0.01);
            translate([0, 0, -0.1])
                cylinder(h = groove_height + 0.2, r = inner_r - groove_depth);
        }
}

// ── Raised text label on outer wall ──────────────────────────
// Placed on the side opposite the handle (–Y face), mid-height
translate([0, -(outer_r + 0.3), bottom_h + inner_h / 2])
    rotate([90, 0, 0])
        linear_extrude(height = 0.8)
            text("3/4 CUP",
                 size    = 7,
                 halign  = "center",
                 valign  = "center",
                 font    = "Liberation Sans:style=Bold");

// ── Handle ───────────────────────────────────────────────────
// Flat rectangular tab extending in +Y from the cup wall,
// centred vertically on the cup, with a finger hole through it.
handle_z = (outer_h - handle_w) / 2;   // Z position so handle is mid-height

translate([0, outer_r - 1, handle_z])
    difference() {
        // Handle solid block
        cube([handle_thick, handle_l + 1, handle_w], center = false);

        // Finger hole centred in the handle
        translate([
            (handle_thick - handle_hole_w) / 2,
            (handle_l + 1 - handle_hole_h) / 2 + 8,
            (handle_w - (handle_w - 4)) / 2
        ])
            cube([handle_hole_w + 0.01, handle_hole_h, handle_w - 4]);
    }
