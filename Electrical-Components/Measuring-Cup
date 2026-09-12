// ============================================
// 3/4 CUP MEASURING CUP
// US cup = 236.588 mL
// 3/4 cup = 177.44 mL
// ============================================

$fn = 96;

// ---------- PARAMETERS ----------

target_volume = 177.44;     // mL (3/4 US cup)

wall = 2.2;                 // wall thickness
bottom = 3.0;               // bottom thickness

inner_radius = 39;          // mm
inner_height = target_volume / (PI * inner_radius * inner_radius);

// Extra height above the 3/4-cup fill volume
extra_height = 8;

outer_radius = inner_radius + wall;
outer_height = inner_height + bottom + extra_height;

// Handle dimensions
handle_width = 10;
handle_length = 55;
handle_round = 8;


// ---------- CUP ----------

difference() {

    // Outer body
    cylinder(
        r = outer_radius,
        h = outer_height
    );

    // Hollow interior
    translate([0, 0, bottom])
        cylinder(
            r = inner_radius,
            h = outer_height
        );

    // Fill-line groove
    translate([0, 0, bottom + inner_height])
        difference() {
            cylinder(
                r = inner_radius + 0.01,
                h = 0.8
            );

            cylinder(
                r = inner_radius - 0.8,
                h = 0.8
            );
        }
}


// ---------- HANDLE ----------

translate([outer_radius - 1, -handle_width/2, outer_height/2])
    rotate([0,90,0])
        difference() {

            // Handle outer shape
            hull() {
                translate([0,0,0])
                    cylinder(
                        r = handle_width/2,
                        h = handle_length
                    );

                translate([0,0,handle_length])
                    cylinder(
                        r = handle_round,
                        h = handle_width
                    );
            }

            // Handle opening
            translate([-1,0,handle_width/2])
                rotate([0,90,0])
                    cylinder(
                        r = handle_width/2 - 2,
                        h = handle_length + 5
                    );
        }


// ---------- MEASUREMENT LABEL ----------

// Raised "3/4 CUP" text
translate([0, -outer_radius - 0.5, outer_height/2])
    rotate([90,0,0])
        linear_extrude(height = 0.8)
            text(
                "3/4 CUP",
                size = 7,
                halign = "center",
                valign = "center",
                font = "Liberation Sans:style=Bold"
            );
