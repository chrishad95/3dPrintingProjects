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

# Registry: @(scad filename, camera string)
$registry = @(
    @("zk-4kx-box.scad", "0,0,19,55,0,340,220")
)

# Filter to the requested model(s)
if ($Model -eq "all") {
    $toRender = $registry
} else {
    $needle   = $Model -replace '\.scad$', ''   # strip extension if supplied
    $toRender = $registry | Where-Object { ($($_[0] -replace '\.scad$', '')) -eq $needle }
    if ($toRender.Count -eq 0) {
        $names = ($registry | ForEach-Object { $_[0] -replace '\.scad$', '' }) -join ', '
        Write-Error "Unknown model '$Model'. Available: $names"
        exit 1
    }
}

foreach ($entry in $toRender) {
    $scad = "$PSScriptRoot\$($entry[0])"
    $stl  = $scad -replace '\.scad$', '.stl'
    $png  = $scad -replace '\.scad$', '.png'
    $cam  = $entry[1]

    Write-Host "==> $($entry[0])" -ForegroundColor Yellow

    Write-Host "  Rendering STL..." -ForegroundColor Cyan
    & $openscad --render --export-format binstl -o $stl $scad
    if ($LASTEXITCODE -ne 0) { Write-Error "STL render failed for $($entry[0])."; exit 1 }
    Write-Host "    -> $stl" -ForegroundColor Green

    Write-Host "  Rendering PNG..." -ForegroundColor Cyan
    & $openscad --render --colorscheme="Tomorrow Night" --imgsize=1024,768 "--camera=$cam" -o $png $scad
    if ($LASTEXITCODE -ne 0) { Write-Error "PNG render failed for $($entry[0])."; exit 1 }
    Write-Host "    -> $png" -ForegroundColor Green
}

Write-Host "All done." -ForegroundColor Green
