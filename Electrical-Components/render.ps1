# ============================================================
#  render.ps1  –  Render Electrical-Components SCAD files to STL and PNG
#
#  Usage:
#    .\render.ps1              – renders all models
#    .\render.ps1 all          – renders all models
#    .\render.ps1 zk-4kx-box   – renders only zk-4kx-box (name without .scad)
#
#  Run from the Electrical-Components directory or from the repo root.
# ============================================================

param(
    [string]$Model = "all"
)

$openscad = "C:\Programs\OpenSCAD-2021.01-x86-64\openscad-2021.01\openscad.exe"

# Registry: @(scad filename, render_part, camera string, output suffix)
# render_part is passed as -D to OpenSCAD; suffix is appended before .stl/.png
# Use suffix="" for the primary/assembly output, "-shell" or "-back" for parts.
$registry = @(
    @("zk-4kx-box.scad", "both",  "0,0,30,55,0,340,260", ""),
    @("zk-4kx-box.scad", "shell", "0,0,25,55,0,340,230", "-shell"),
    @("zk-4kx-box.scad", "back",  "0,0,0,0,0,0,200",     "-back")
)

# Build a unique list of model base names for the -Model filter
$modelNames = ($registry | ForEach-Object { $_[0] -replace '\.scad$', '' } | Select-Object -Unique)

# Filter to the requested model(s)
if ($Model -eq "all") {
    $toRender = $registry
} else {
    $needle   = $Model -replace '\.scad$', ''   # strip extension if supplied
    $toRender = $registry | Where-Object { ($($_[0] -replace '\.scad$', '')) -eq $needle }
    if ($toRender.Count -eq 0) {
        $names = $modelNames -join ', '
        Write-Error "Unknown model '$Model'. Available: $names"
        exit 1
    }
}

foreach ($entry in $toRender) {
    $base   = "$PSScriptRoot\$($entry[0] -replace '\.scad$', '')"
    $part   = $entry[1]
    $cam    = $entry[2]
    $suffix = $entry[3]
    $scad   = "$base.scad"
    $stl    = "$base$suffix.stl"
    $png    = "$base$suffix.png"

    Write-Host "==> $($entry[0]) [$part]" -ForegroundColor Yellow

    Write-Host "  Rendering STL..." -ForegroundColor Cyan
    & $openscad --render --export-format binstl -D "render_part=`"$part`"" -o $stl $scad
    if ($LASTEXITCODE -ne 0) { Write-Error "STL render failed for $($entry[0]) [$part]."; exit 1 }
    Write-Host "    -> $stl" -ForegroundColor Green

    Write-Host "  Rendering PNG..." -ForegroundColor Cyan
    & $openscad --render --colorscheme="Tomorrow Night" --imgsize=1024,768 "--camera=$cam" -D "render_part=`"$part`"" -o $png $scad
    if ($LASTEXITCODE -ne 0) { Write-Error "PNG render failed for $($entry[0]) [$part]."; exit 1 }
    Write-Host "    -> $png" -ForegroundColor Green
}

Write-Host "All done." -ForegroundColor Green
