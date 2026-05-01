# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A set of equivalent utility scripts (bash, zsh, PowerShell) that reorganise the [TOSEC ZX Spectrum collection](https://archive.org/details/zx_spectrum_tosec_set_september_2023) into a folder structure compatible with [The Spectrum](https://retrogames.biz/products/thespectrum/) retro console, then download the original Spectrum ROMs from FBZX.

## Running the Scripts

Scripts must be run from the directory containing both the script and the unzipped `Games/` folder.

**Linux/macOS — bash:**
```bash
chmod +x zx-spectrum-tosec-util.bash
./zx-spectrum-tosec-util.bash
```

**Linux/macOS — zsh:**
```bash
chmod +x zx-spectrum-tosec-util.zsh
./zx-spectrum-tosec-util.zsh
```

**Windows — PowerShell:**
```powershell
powershell.exe -ExecutionPolicy Bypass
.\zx-spectrum-tosec-util.ps1
```

## How the Scripts Work

All three scripts implement the same logic:

1. **Input**: `Games/` directory from the TOSEC archive, where each subdirectory is a game title.
2. **Filtering**: Skips entries whose name starts with `!` (TOSEC uses this prefix for non-game entries).
3. **Bucketing**: Groups games alphabetically — digits map to `#`, letters to their uppercase initial. Within each letter bucket, games are split into groups of 256 (e.g. `A0`, `A1`, `A2`…) because The Spectrum supports at most 256 files per folder.
4. **Output**: Copies supported game files (`tap`, `tzx`, `pzx`, `rom`, `szx`, `z80`, `sna`, `m3u`) into `THESPECTRUM/<bucket>/<game title>/`.
5. **ROMs**: Creates `THESPECTRUM/roms/` and downloads the seven Spectrum ROM files (48K, 128K, +3) from the FBZX GitHub repo.

The `.gitignore` excludes `Games*/` and `THESPECTRUM/` — these are large runtime artefacts, not source.

## Key Differences Between Script Variants

| | bash | zsh | PowerShell |
|---|---|---|---|
| Glob no-match handling | `shopt -s nullglob` | `setopt +o nomatch` | implicit |
| Digit→`#` mapping | `tr '[:digit:]' '#'` | `tr '[:digit:]' '#'` | not implemented — digits sort before `A` naturally |
| ROM download | `curl -O` | `curl -O` | `Invoke-WebRequest` |

When making changes, keep all three scripts in sync with each other.
