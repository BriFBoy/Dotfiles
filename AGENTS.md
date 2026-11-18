# AGENTS.md

Guidance for AI agents working in this repository.

## Git

**Never touch git** — no commits, pushes, or other git commands. Version
control is the user's job: make and verify the changes, then report them.

## What this is

Personal dotfiles for a **Fedora + Hyprland** setup. Each top-level directory
is a package that mirrors the home directory — e.g.
`hyprland/.config/hypr/hyprland.lua` symlinks to `~/.config/hypr/hyprland.lua`,
and `bash/.bashrc` to `~/.bashrc`. Packages are managed with
[doty](https://github.com/BriFBoy/doty); the layout stays
[stow](https://www.gnu.org/software/stow/)-compatible.

## Layout conventions

- **One directory per app**, named after it (`ghostty/`, `rofi/`, `tmux/`, ...).
- **Replicate the target path**: configs go in `.config/<app>/`, dotfiles
  (`.bashrc`, `.tmux.conf`, `.gitconfig`) go at the package root.
- **New app**: create the package directory, then add a `dot.toml` and a
  `fedora.sh` stub (copy an existing package's). Add it to a `[bundles]` group
  in `doty.toml` if it belongs to one.
- **`Scripts/`** (capital S) holds helper scripts, outside the package structure.
- **`doc/`** holds README screenshots.

## doty setup

Each package carries a `dot.toml` + a `fedora.sh` hook; `doty.toml` at the repo
root configures the project. Run doty from the repo root.

- **`dot.toml`** (per package): `exclude` lists the top-level paths `doty link`
  must skip — always `dot.toml` + the hook script, so they aren't symlinked into
  `$HOME`. A per-OS table (e.g. `[fedora]`) maps an OS ID (the `ID` from
  `/etc/os-release`) to that OS's hook script.
- **`fedora.sh`** (per package): the OS hook, which doty runs as `fedora.sh
  install` / `fedora.sh uninstall`. **Rule: a hook only sets up its own package
  and must be idempotent** (safe to re-run). Stubs are no-ops for now.
- **`doty.toml`** (root): `[packages] conflict = "backup"` plus (later)
  `[bundles]` — named groups for `doty bundle install <name>`.

`doty link <pkg>` symlinks a package; `doty install <pkg>` runs its hook.
`stow <pkg>` still works on the same layout.

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
| `hyprland/.config/hypr/noctalia.lua` (gitignored) | `noctalia/.config/noctalia/config.toml` |
| `dunst/.config/dunst/dunstrc` (gitignored) | `dunst/.config/dunst/dunstrc.template` |

The wallpaper switcher runs `Scripts/setWallpaper.sh`, which regenerates the
pywal palette and `dunstrc`.

On a fresh clone `noctalia.lua` doesn't exist until Noctalia runs — the
`hyprland.start` autostart regenerates it from `config.toml`. `hyprland.lua`
guards the `require("noctalia")` with `pcall`, so the first boot loads
unthemed instead of erroring.

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
bash -n Scripts/*.sh */fedora.sh  # shell syntax
nvim --headless -c 'qa'           # catches neovim config errors
```

- **Waybar**: `config.jsonc` is JSON *with comments* — a strict JSON parser
  fails on it by design.
- **Hyprland**: only fully verifies in a live session; check it parses with
  `luac -p` as a first step.

## Gotchas

- **doty `link` is non-destructive** — with `conflict = "backup"` a clashing
  real file is moved to `name.bak` before symlinking. `stow` has no such
  exclude, so it will also symlink each package's `dot.toml`/`fedora.sh` into
  `$HOME` (harmless).
- **`dunst/.config/dunst/dunstrc`** and cava shaders/themes are gitignored
  generated artifacts — don't commit them.
- **Personal repo** — keep changes aligned with the existing structure rather
  than "improving" the install flow unless asked.
