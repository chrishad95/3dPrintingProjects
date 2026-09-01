# Trailer Jack Stand Cap - Technical Specification

This folder contains two high-performance parametric 3D-printable caps designed to fit into a standard trailer jack stand pipe. The caps prevent rainwater, dirt, and debris from entering the pipe, which helps eliminate internal rust and extends the service life of the jack stand.

---

## 1. Pipe Interface Specifications
These caps are precisely engineered to interface with a heavy-duty steel pipe with the following dimensions:

| Dimension | Imperial | Metric (Converted) |
| :--- | :--- | :--- |
| **Pipe Outer Diameter (OD)** | $2.0\text{ in}$ | $50.80\text{ mm}$ |
| **Pipe Inner Diameter (ID)** | $1\ \frac{13}{16}\text{ in}$ ($1.8125\text{ in}$) | $46.0375\text{ mm}$ |
| **Pipe Wall Thickness** | $\frac{3}{32}\text{ in}$ ($0.09375\text{ in}$) | $2.38125\text{ mm}$ |

---

## 2. Shared Cap Engineering Requirements
- **Total Cap Height**: $25.0\text{ mm}$ (from top edge to bottom insertion tip)
- **Minimum Wall Thickness**: $3.5\text{ mm}$ (exceeds the safety minimum of $3.0\text{ mm}$ to ensure high structural strength under impact and compression)
- **Fit Tolerance (Clearance)**: $0.25\text{ mm}$ off the inner diameter to allow a snug but manageable push-fit inside the pipe (Actual plug outer diameter is $45.7875\text{ mm}$)
- **Insertion Chamfer**: A $2.0\text{ mm}$ lead-in taper/bevel on the bottom of the plug ensures self-alignment during insertion.
- **Spring-Loaded Tension Tabs**: Two opposite cantilever tabs cut directly into the plug walls provide automatic spring-loaded retention inside the pipe.
  - **Tab Width**: $9.5\text{ mm}$
  - **Separation Slits**: $1.2\text{ mm}$ wide vertical cuts extending $8.5\text{ mm}$ up the plug, leaving $1.5\text{ mm}$ of material at the top to act as a pivot.
  - **Tension Bumps**: A horizontal half-cylinder bump with a $1.0\text{ mm}$ radius that protrudes $0.6\text{ mm}$ radially outwards from the plug outer surface (positioned $3.5\text{ mm}$ from the plug tip). This bump compresses against the pipe inner wall, deflecting the cantilever tabs inward and holding the cap securely in place with friction.

---

## 3. Cap Variants

### Variant A: Flat-Top Cap (`Trailer-Jack-Cap.scad`)
The standard design featuring a flat top lip that rests flush on the pipe rim.
- **Flange/Lip Outer Diameter**: $50.8\text{ mm}$ (matches pipe OD)
- **Flange/Lip Height**: $15.0\text{ mm}$ (portion of cap staying outside the pipe)
- **Insert Depth (Plug Height)**: $10.0\text{ mm}$ (portion inside the pipe)
- **Cavity Style**: Cylindrical core, hollowed from the bottom (plug end), closed at the top (flange end) with a solid $3.5\text{ mm}$ top face.
- **Slicing/Print Orientation**:
  - **Orientation**: Print **flange-down** (flat top on the build plate).
  - **Supports**: **0% Support Required**. The diameter decreases as layers go up, making it 100% support-free and overhang-free.

---

### Variant B: Round-Top Cap (`Trailer-Jack-Cap-Round-Top.scad`)
An advanced design featuring a smooth, rounded dome that actively sheds water and provides a highly finished look. To prevent a fragile knife-like edge on the outer perimeter, this design incorporates a **2.0 mm vertical rim edge** before the curved dome begins.
- **Base Flange Outer Diameter**: $50.8\text{ mm}$ (matches pipe OD)
- **Flange Height**: $15.0\text{ mm}$ (total height staying outside the pipe)
  - **Vertical Edge/Rim**: $2.0\text{ mm}$ (vertical edge to ensure a robust, non-fragile perimeter)
  - **Spherical Dome**: $13.0\text{ mm}$ (portion curving upward above the vertical rim)
- **Insert Depth (Plug Height)**: $10.0\text{ mm}$ (portion inside the pipe)
- **Dome Radius (Outer)**: $31.3138\text{ mm}$ (spherical cap formula: $R = \frac{r^2 + h^2}{2h}$)
- **Internal Cavity Style**: Double-curved cavity with a matching $2.0\text{ mm}$ cylindrical rim cavity and an internal dome ($9.5\text{ mm}$ height, $24.5457\text{ mm}$ radius) to maintain a perfectly uniform $3.5\text{ mm}$ wall thickness.
- **Slicing/Print Orientation**:
  - **Orientation**: Print **plug-down** (open cavity flat on the build plate).
  - **Supports**: **0% Support Required**. The internal cavity transitions into a self-supporting dome structure that 3D printers can bridge effortlessly without internal supports, while the outer dome prints upwards with a pristine surface.

---

## 4. Suggested Print Settings

| Setting | Recommended Value | Reasoning |
| :--- | :--- | :--- |
| **Material** | TPU (95A or 98A), PETG, or ASA | TPU is highly recommended for impact-resistance and airtight fit. PETG and ASA provide excellent UV/weather resistance. Avoid standard PLA due to moisture and UV degradation outdoors. |
| **Layer Height** | $0.20\text{ mm}$ or $0.24\text{ mm}$ | Balance of print speed and clean contours on the dome. |
| **Wall Loops (Perimeters)** | $4$ perimeters | Maximizes wall strength (ensures the walls are solid plastic). |
| **Top/Bottom Shells** | $4$ layers | Prevents pinholes and ensures a perfectly sealed waterproof top. |
| **Infill Density** | $25\% - 40\%$ | High density ensures robust walls and high crush resistance. |
| **Infill Pattern** | Gyroid, 3D Honeycomb, or Grid | Promotes uniform strength in all three physical axes. |
