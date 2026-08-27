# AGENTS.md

Guidance for AI agents working in this repository.

## What this is

Personal dotfiles for an **Arch Linux + Hyprland** setup. Each top-level
directory is a [stow](https://www.gnu.org/software/stow/) package that mirrors
the home directory — e.g. `hyprland/.config/hypr/hyprland.lua` symlinks to
`~/.config/hypr/hyprland.lua`, and `bash/.bashrc` to `~/.bashrc`.

## Layout conventions

- **One directory per app**, named after it (`ghostty/`, `rofi/`, `tmux/`, ...).
- **Replicate the target path**: configs go in `.config/<app>/`, dotfiles
  (`.bashrc`, `.tmux.conf`, `.gitconfig`) go at the package root.
- **New app**: create the package directory, then add it to the `stow` commands
  in `install.sh`.
- **`Scripts/`** (capital S) holds helper scripts, outside the stow structure.
- **`doc/`** holds README screenshots.

## Hyprland config

Uses the **modern Lua API** (`hl.config`, `hl.bind`, `hl.dsp.*`, `hl.monitor`,
...), not the legacy INI format.
Reference: https://wiki.hypr.land/Configuring/Start/

Config is split into modules, each required from `hyprland.lua`. Keep new
settings in the right one: `keybinds.lua`, `autostart.lua`,
`look_and_feel.lua`, `noctalia.lua`.

> `.luarc.json` points the Lua LSP at `/usr/share/hypr/stubs` (Hyprland API
> stubs). It's gitignored and only resolves where Hyprland is installed, so
> "unknown symbol hl" warnings elsewhere are expected.

## Colors & theming

Colors come from **pywal** (`wal`) — a palette generated from the current
wallpaper — and **Noctalia**, which applies it to Hyprland.

**Rule: don't hardcode palettes.** Reference pywal/noctalia variables where the
app supports it.

Two files are **generated** — edit the source, never the output:

| Generated file (don't edit) | Edit this instead |
| --- | --- |
| `hyprland/.config/hypr/noctalia.lua` | `noctalia/.config/noctalia/config.toml` |
| `dunst/.config/dunst/dunstrc` (gitignored) | `dunst/.config/dunst/dunstrc.template` |

The wallpaper switcher runs `Scripts/setWallpaper.sh`, which regenerates the
pywal palette and `dunstrc`.

## Code style

- **Lua**: tabs for indentation. Run `stylua .` before committing (root
  `.stylua.toml`: `collapse_simple_statement = "Always"`).
- **Neovim**: see `neovim/.config/nvim/AGENTS.md` for structure, the driver
  pattern, and conventions.
- **Shell**: bash, `#!/bin/bash` (or `#!/usr/bin/env sh` for tiny scripts).
- **Commits**: short, lowercase, imperative — e.g. `added rust-analyzer to
  nvim`, `fixed nvim-jdtls`.

## Verification

```bash
stylua --check .                  # Lua formatting (needs stylua)
bash -n install.sh Scripts/*.sh   # shell syntax
nvim --headless -c 'qa'           # catches neovim config errors
```

- **Waybar**: `config.jsonc` is JSON *with comments* — a strict JSON parser
  fails on it by design.
- **Hyprland**: only fully verifies in a live session; check it parses with
  `luac -p` as a first step.

## Gotchas

- **`install.sh` is destructive** — it deletes existing dotfiles
  (`rm -rf ~/.bashrc`) and only works on a clean Arch install (assumes yay).
- **`dunst/.config/dunst/dunstrc`** and cava shaders/themes are gitignored
  generated artifacts — don't commit them.
- **Personal repo** — keep changes aligned with the existing structure rather
  than "improving" the install flow unless asked.
