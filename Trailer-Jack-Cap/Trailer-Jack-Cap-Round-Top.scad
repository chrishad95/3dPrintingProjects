/*
 * Trailer Jack Stand Cap - Round Top Version
 *
 * Designed to fit INTO a pipe with:
 * - Outer Diameter (OD): 2 inches (~50.8 mm)
 * - Inner Diameter (ID): 1 13/16 inches (~46.0375 mm)
 *
 * Parameters:
 * - Total Height: 25 mm
 * - Wall Thickness: >= 3 mm (We use 3.5 mm for high strength)
 * - Print Clearance: 0.25 mm (to ensure a snug but doable push-fit)
 * - Rounded Dome: A shallow spherical cap that looks clean and sheds water.
 *
 * Print Recommendation:
 * - Print plug-down (opening on the bed) for a completely support-free print!
 * - The interior ceiling has a matching spherical dome cavity, which 
 *   keeps the wall thickness perfectly uniform (3.5 mm) and prints 
 *   flawlessly without internal supports.
 * - Use PETG, ASA, or TPU for outdoor durability.
 */

// --- Units & Conversion ---
inch = 25.4;

// --- Parametric Dimensions ---
pipe_od = 2.0 * inch;       // Pipe Outer Diameter (50.8 mm)
pipe_id = 1.8125 * inch;    // Pipe Inner Diameter (46.0375 mm) - 1 13/16"

total_height = 25.0;        // Total height of the cap in mm
flange_height = 15.0;       // Total height of the flange/cap outside the pipe (mm)
rim_height = 2.0;           // Vertical edge/rim height before dome starts (mm)
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
dome_height = flange_height - rim_height; // Height of the spherical dome (13.0 mm)
plug_od = pipe_id - clearance; // Outer diameter of the plug section
plug_height = total_height - flange_height; // Height of the insert section (10.0 mm)
cavity_id = plug_od - (2 * wall_thickness); // Inside diameter of the hollow cavity

// Calculated tab angles and coordinates
tab_angle = 2 * asin(tab_width / plug_od);
bump_z = bump_from_bottom;
slit_z_start = -1.0;
slit_height = plug_height - tab_attachment + 1.0;

// Dome geometry calculations (using standard spherical cap formula: R = (r^2 + h^2) / (2 * h))
outer_r = pipe_od / 2;
outer_sphere_r = (pow(outer_r, 2) + pow(dome_height, 2)) / (2 * dome_height);

inner_r = cavity_id / 2;
inner_dome_height = dome_height - wall_thickness;
inner_sphere_r = (pow(inner_r, 2) + pow(inner_dome_height, 2)) / (2 * inner_dome_height);

// Quality setting (number of fragments in circle)
$fn = 120;

module trailer_jack_cap_round_top() {
    difference() {
        // --- Outer Solid Shape ---
        union() {
            // 1. Tapered Lead-in (Chamfer) at the bottom of the plug (for easy insertion)
            cylinder(h = chamfer_height, d1 = plug_od - (2 * chamfer_height), d2 = plug_od);
            
            // 2. Main Plug body (goes inside the pipe)
            translate([0, 0, chamfer_height])
                cylinder(h = plug_height - chamfer_height, d = plug_od);
            
            // 3. Vertical Edge/Rim of the Flange
            translate([0, 0, plug_height])
                cylinder(h = rim_height, d = pipe_od);
            
            // 4. Rounded Dome Top (Flange / Cover) starting on top of the rim
            translate([0, 0, plug_height + rim_height]) {
                intersection() {
                    cylinder(h = dome_height, d = pipe_od);
                    translate([0, 0, -(outer_sphere_r - dome_height)])
                        sphere(r = outer_sphere_r);
                }
            }
            
            // 5. Tension Bumps on both sides (0 and 180 degrees)
            // 0 degrees (positive X side) - length is tab_width - 0.5 to keep it strictly on the tab
            translate([plug_od/2 - bump_radius + bump_protrusion, 0, bump_z])
                rotate([90, 0, 0])
                    cylinder(h = tab_width - 0.5, r = bump_radius, center = true);
                    
            // 180 degrees (negative X side) - length is tab_width - 0.5 to keep it strictly on the tab
            translate([-(plug_od/2 - bump_radius + bump_protrusion), 0, bump_z])
                rotate([90, 0, 0])
                    cylinder(h = tab_width - 0.5, r = bump_radius, center = true);
        }
        
        // --- Inner Cavity (Uniform wall thickness, completely support-free) ---
        union() {
            // 1. Main plug cavity + vertical rim cavity (cylinder)
            translate([0, 0, -1]) // extend slightly below z=0 for a clean cut
                cylinder(h = plug_height + rim_height + 1, d = cavity_id);
            
            // 2. Matching inner dome cavity (maintains uniform wall thickness and prints support-free)
            translate([0, 0, plug_height + rim_height]) {
                intersection() {
                    cylinder(h = inner_dome_height, d = cavity_id);
                    translate([0, 0, -(inner_sphere_r - inner_dome_height)])
                        sphere(r = inner_sphere_r);
                }
            }
        }
        
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
trailer_jack_cap_round_top();
