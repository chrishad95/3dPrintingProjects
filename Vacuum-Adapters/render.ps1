# ============================================================
#  render.ps1  –  Render Vacuum-Adapters SCAD files to STL and PNG
#
#  Usage:
#    .\render.ps1              – renders all models
#    .\render.ps1 all          – renders all models
#    .\render.ps1 adapter-01   – renders only adapter-01 (name without .scad)
#
#  Run from the Vacuum-Adapters directory or from the repo root.
# ============================================================

param(
    [string]$Model = "all"
)

$openscad = "C:\Programs\OpenSCAD-2021.01-x86-64\openscad-2021.01\openscad.exe"

# Registry: @(scad filename, camera string)
$registry = @(
    @("adapter-01.scad", "0,0,38,55,0,25,200"),
    @("adapter-02.scad", "0,0,25,55,0,25,180"),
    @("adapter-03.scad", "0,0,42,55,0,25,200"),
    @("test-ring.scad",  "0,0,2,55,0,25,150"),
    @("Shop-Vac-to-Attachment.scad", "0,0,55,55,0,25,250")
)

# Filter to the requested model(s)
if ($Model -eq "all") {
    $toRender = $registry
} else {
    $needle   = $Model -replace '\.scad$', ''   # strip extension if supplied
    $toRender = @($registry | Where-Object { ($($_[0] -replace '\.scad$', '')) -eq $needle })
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
    & $openscad --render --export-format binstl -o $stl $scad 2>$null
    Write-Host "    -> $stl" -ForegroundColor Green

    Write-Host "  Rendering PNG..." -ForegroundColor Cyan
    & $openscad --render --colorscheme="Tomorrow Night" --imgsize=1024,768 "--camera=$cam" -o $png $scad 2>$null
    Write-Host "    -> $png" -ForegroundColor Green
}

Write-Host "All done." -ForegroundColor Green
