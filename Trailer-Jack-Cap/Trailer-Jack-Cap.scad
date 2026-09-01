/*
 * Trailer Jack Stand Cap
 *
 * Designed to fit INTO a pipe with:
 * - Outer Diameter (OD): 2 inches (~50.8 mm)
 * - Inner Diameter (ID): 1 13/16 inches (~46.0375 mm)
 *
 * Parameters:
 * - Total Height: 25 mm
 * - Wall Thickness: >= 3 mm (We use 3.5 mm for high strength)
 * - Print Clearance: 0.25 mm (to ensure a snug but doable push-fit)
 *
 * Print Recommendation:
 * - Print flange-down (default orientation) for a smooth top surface 
 *   and no support material required.
 * - Use PETG, ASA, or TPU for outdoor durability.
 */

// --- Units & Conversion ---
inch = 25.4;

// --- Parametric Dimensions ---
pipe_od = 2.0 * inch;       // Pipe Outer Diameter (50.8 mm)
pipe_id = 1.8125 * inch;    // Pipe Inner Diameter (46.0375 mm) - 1 13/16"

total_height = 25.0;        // Total height of the cap in mm
flange_height = 15.0;      // Thickness of the flange/cap lip that sits on the pipe rim (mm)
wall_thickness = 3.5;      // Thickness of the walls (must be >= 3.0 mm)
clearance = 0.25;          // Tolerance/clearance for 3D printing fit inside the pipe (mm)
chamfer_height = 2.0;      // Height of the lead-in chamfer at the bottom of the plug

// --- Tab Parameters ---
tab_width = 9.5;            // Width of each tension tab in mm
slit_width = 1.2;           // Width of the vertical cuts defining the tab (mm)
bump_radius = 1.0;          // Profile radius of the horizontal contact bump (mm)
bump_protrusion = 0.6;      // Height the bump protrudes from the plug OD (mm)
bump_from_bottom = 3.5;     // Distance of the bump center from the plug tip (mm)
tab_attachment = 1.5;       // Height of material keeping the tab attached near the flange (mm)

// --- Calculated Values ---
plug_od = pipe_id - clearance; // Outer diameter of the plug section
plug_height = total_height - flange_height; // Height of the insert section
cavity_id = plug_od - (2 * wall_thickness); // Inside diameter of the hollow cavity

// Calculated tab angles and coordinates
tab_angle = 2 * asin(tab_width / plug_od);
bump_z = total_height - bump_from_bottom;
slit_z_start = flange_height + tab_attachment;
slit_height = plug_height - tab_attachment + 1.0;

// Quality setting (number of fragments in circle)
$fn = 120;

module trailer_jack_cap() {
    difference() {
        // --- Outer Solid Shape ---
        union() {
            // Flange (Lid) - Sits on top of the pipe
            cylinder(h = flange_height, d = pipe_od);
            
            // Main Plug body (goes inside the pipe)
            translate([0, 0, flange_height])
                cylinder(h = plug_height - chamfer_height, d = plug_od);
            
            // Beveled Lead-in (Chamfer) at the end of the plug for easy insertion
            translate([0, 0, flange_height + plug_height - chamfer_height])
                cylinder(h = chamfer_height, d1 = plug_od, d2 = plug_od - (2 * chamfer_height));
                
            // Tension Bumps on both sides (0 and 180 degrees)
            // 0 degrees (positive X side)
            translate([plug_od/2 - bump_radius + bump_protrusion, 0, bump_z])
                rotate([90, 0, 0])
                    cylinder(h = tab_width + 4, r = bump_radius, center = true);
                    
            // 180 degrees (negative X side)
            translate([-(plug_od/2 - bump_radius + bump_protrusion), 0, bump_z])
                rotate([90, 0, 0])
                    cylinder(h = tab_width + 4, r = bump_radius, center = true);
        }
        
        // --- Inner Cavity (Hollow out the cap to save material and meet wall thickness) ---
        // Cavity starts at 'wall_thickness' from the bottom of the cap
        translate([0, 0, wall_thickness])
            cylinder(h = total_height + 1, d = cavity_id);
            
        // --- Slits for the Tabs (0 and 180 degrees) ---
        // We cut the slits radially outwards from the center
        for (angle = [tab_angle/2, -tab_angle/2, 180 + tab_angle/2, 180 - tab_angle/2]) {
            rotate([0, 0, angle])
                translate([0, -slit_width/2, slit_z_start])
                    cube([plug_od/2 + 2, slit_width, slit_height]);
        }
    }
}

// Instantiate the cap
trailer_jack_cap();
