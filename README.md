# 3D Printing Projects

A personal collection of 3D-printable parts created primarily with **AI assistance** and **[OpenSCAD](https://openscad.org/)** — a code-based solid modelling tool that lets every design be fully parametric, version-controlled, and reproducible.

---

## About This Repo

Each project in this repo is something I actually needed — a replacement part, an adapter, a protective cap. Rather than searching for an off-the-shelf print or hand-drawing a model, I use AI to help author the OpenSCAD code, iterate on dimensions, and catch geometry bugs before anything hits the printer.

All designs are:
- **Parametric** — key dimensions are named variables at the top of each `.scad` file, easy to tweak
- **Version-controlled** — every change is committed with a clear explanation
- **Self-contained** — each project folder includes the `.scad` source, rendered `.stl`, and a preview `.png`

---

## Projects

### 🪣 Boat Ladder Bracket
**Folder:** [`Boat-Ladder-Bracket/`](Boat-Ladder-Bracket/)

A replacement clip for a broken plastic boat ladder bracket. Designed to snap over a 1-inch (25.4 mm) tube with spring retention beads and a rear mounting bolt hole.

| File | Description |
|---|---|
| [`ladder-clip.scad`](Boat-Ladder-Bracket/ladder-clip.scad) | Parametric OpenSCAD source |
| [`ladder-clip.stl`](Boat-Ladder-Bracket/ladder-clip.stl) | Print-ready STL |
| [`ladder-clip.png`](Boat-Ladder-Bracket/ladder-clip.png) | Rendered preview |

---

### 🔧 Trailer Jack Cap
**Folder:** [`Trailer-Jack-Cap/`](Trailer-Jack-Cap/)

Protective caps for a trailer jack stand pipe (2-inch OD steel pipe). Keeps rain, dirt, and debris out to prevent internal rust. Two variants:

- **Flat-top cap** — flush flange, print flange-down, zero supports
- **Round-top cap** — domed water-shedding top, print plug-down, zero supports

Both use spring-loaded cantilever retention tabs for a secure push-fit inside the pipe.

| File | Description |
|---|---|
| [`Trailer-Jack-Cap.scad`](Trailer-Jack-Cap/Trailer-Jack-Cap.scad) | Flat-top variant source |
| [`Trailer-Jack-Cap-Round-Top.scad`](Trailer-Jack-Cap/Trailer-Jack-Cap-Round-Top.scad) | Round-top variant source |
| [`Trailer-Jack-Cap-Specification.md`](Trailer-Jack-Cap/Trailer-Jack-Cap-Specification.md) | Full engineering specification |

---

### 🌀 Vacuum Adapters
**Folder:** [`Vacuum-Adapters/`](Vacuum-Adapters/)

A set of adapters to connect vacuum hoses and attachments with mismatched diameters.

| Adapter | Description | Key Dimensions |
|---|---|---|
| [`adapter-01.scad`](Vacuum-Adapters/adapter-01.scad) | Reducer — spigot end fits inside tube 1, socket end receives tube 2 | Tube 1 ID: 34 mm · Tube 2 OD: 37.8 mm · Length: 76 mm (3 in) |
| [`adapter-02.scad`](Vacuum-Adapters/adapter-02.scad) | Same-size coupler — joins two identical tubes | Both tube OD: 41 mm · Length: 51 mm (2 in) |
| [`adapter-03.scad`](Vacuum-Adapters/adapter-03.scad) | Attachment coupler — deep socket for attachment, shallow socket for tube | Attachment OD: 40 mm · Tube OD: 41 mm · Length: 85 mm |

A [`render.ps1`](Vacuum-Adapters/render.ps1) PowerShell script re-renders all adapters to STL and PNG after any `.scad` edit.

---

## Tools & Setup

| Tool | Purpose |
|---|---|
| [OpenSCAD](https://openscad.org/) | Solid modelling from code (installed at `C:\Programs\OpenSCAD-2021.01-x86-64\`) |
| AI (IBM Bob) | Authoring and iterating on OpenSCAD code, debugging geometry |
| Git | Version control for all source files and rendered outputs |

---

## Repository Structure

```
3dPrintingProjects/
├── Boat-Ladder-Bracket/       # Boat ladder replacement clip
├── Trailer-Jack-Cap/          # Trailer jack stand pipe caps
├── Vacuum-Adapters/           # Vacuum hose adapters
│   └── render.ps1             # Script to re-render all adapters
└── README.md
```

---

## Printing Notes

- Designs are exported as **binary STL** and sliced in your slicer of choice
- Tolerances use **0.25–0.3 mm radial clearance** for push-fit connections — adjust `*_clear` variables in each `.scad` file if your printer runs tight or loose
- Recommended materials vary by project; see individual specification files for guidance
