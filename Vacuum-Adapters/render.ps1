# ============================================================
#  render.ps1  –  Render all vacuum adapter SCAD files to STL and PNG
#  Run from the Vacuum-Adapters directory or from the repo root.
# ============================================================

$openscad = "C:\Programs\OpenSCAD-2021.01-x86-64\openscad-2021.01\openscad.exe"

# Each entry: @(scad file, camera string)
$adapters = @(
    @("adapter-01.scad", "0,0,38,55,0,25,200"),
    @("adapter-02.scad", "0,0,25,55,0,25,180")
)

foreach ($entry in $adapters) {
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
