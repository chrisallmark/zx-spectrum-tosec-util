#!/bin/zsh
setopt NULL_GLOB

src="Games"

if [[ ! -d "$src" ]]; then
    echo "Error: Games/ directory not found. Unzip the TOSEC archive here first." >&2
    exit 1
fi

folder=""
folder_ext=""
for i in "$src"/*/; do
    if [[ "${$(basename "$i"):0:1}" != "!" ]]; then
        file=$(basename "$i")
        letter=$(echo "${file:0:1}" | tr '[:digit:]' '#' | tr '[:lower:]' '[:upper:]')
        if [[ "$folder" != "$letter" ]]; then
            count=0
            folder=$letter
        fi
        folder_ext=$((count++ / 256))
        dest="THESPECTRUM/$folder$folder_ext/$file"
        echo "Processing: $file"
        mkdir -p "$dest"
        for f in "$i"*.{tap,tzx,pzx,rom,szx,z80,sna,m3u}; do
            [[ -f "$f" ]] && mv "$f" "$dest"
        done
        if [[ -z "$(ls -A "$dest")" ]]; then
            rmdir "$dest"
        fi
    fi
done

mkdir -p THESPECTRUM/roms
# To pin to a specific FBZX release, replace "refs/heads/master" with a commit SHA.
curl -fO --output-dir THESPECTRUM/roms https://github.com/rastersoft/fbzx/raw/refs/heads/master/data/spectrum-roms/128-0.rom
curl -fO --output-dir THESPECTRUM/roms https://github.com/rastersoft/fbzx/raw/refs/heads/master/data/spectrum-roms/128-1.rom
curl -fO --output-dir THESPECTRUM/roms https://github.com/rastersoft/fbzx/raw/refs/heads/master/data/spectrum-roms/48.rom
curl -fO --output-dir THESPECTRUM/roms https://github.com/rastersoft/fbzx/raw/refs/heads/master/data/spectrum-roms/plus3-0.rom
curl -fO --output-dir THESPECTRUM/roms https://github.com/rastersoft/fbzx/raw/refs/heads/master/data/spectrum-roms/plus3-1.rom
curl -fO --output-dir THESPECTRUM/roms https://github.com/rastersoft/fbzx/raw/refs/heads/master/data/spectrum-roms/plus3-2.rom
curl -fO --output-dir THESPECTRUM/roms https://github.com/rastersoft/fbzx/raw/refs/heads/master/data/spectrum-roms/plus3-3.rom
