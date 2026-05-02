Set-StrictMode -Version Latest
$src = "Games"
if (-not (Test-Path -PathType Container $src)) {
    Write-Error "Games\ directory not found. Unzip the TOSEC archive here first."
    exit 1
}
$folder = ""
$folder_ext = 0
Get-ChildItem -Directory -Path $src | ForEach-Object {
    $file = $_.Name
    if ($file.StartsWith('!')) { return }
    $firstChar = $file.Substring(0, 1)
    $letter = if ($firstChar -match '\d') { '#' } else { $firstChar.ToUpper() }
    if ($folder -ne $letter) {
        $count = 0
        $folder = $letter
    }
    $folder_ext = [math]::Floor($count / 256)
    $count++
    Write-Host "Processing: $file"
    $dest = "THESPECTRUM\$folder$folder_ext\$file"
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Get-ChildItem -Path "$($_.FullName)\*" -Include *.tap, *.tzx, *.pzx, *.rom, *.szx, *.z80, *.sna, *.m3u | ForEach-Object {
        if (Test-Path -LiteralPath $_.FullName) {
            Move-Item -LiteralPath $_.FullName -Destination $dest
        }
    }
    if (-not (Get-ChildItem -Path $dest -Force)) {
        Remove-Item -Path $dest
    }
}
$romsDir = "THESPECTRUM\roms"
New-Item -ItemType Directory -Force -Path $romsDir | Out-Null
# To pin to a specific FBZX release, replace "refs/heads/master" with a commit SHA.
$urls = @(
    "https://github.com/rastersoft/fbzx/raw/refs/heads/master/data/spectrum-roms/128-0.rom",
    "https://github.com/rastersoft/fbzx/raw/refs/heads/master/data/spectrum-roms/128-1.rom",
    "https://github.com/rastersoft/fbzx/raw/refs/heads/master/data/spectrum-roms/48.rom",
    "https://github.com/rastersoft/fbzx/raw/refs/heads/master/data/spectrum-roms/plus3-0.rom",
    "https://github.com/rastersoft/fbzx/raw/refs/heads/master/data/spectrum-roms/plus3-1.rom",
    "https://github.com/rastersoft/fbzx/raw/refs/heads/master/data/spectrum-roms/plus3-2.rom",
    "https://github.com/rastersoft/fbzx/raw/refs/heads/master/data/spectrum-roms/plus3-3.rom"
)
try {
    foreach ($url in $urls) {
        Invoke-WebRequest -Uri $url -OutFile (Join-Path $romsDir (Split-Path -Leaf $url)) -ErrorAction Stop
    }
} catch {
    Write-Error "Failed to download ROM: $_"
    exit 1
}
