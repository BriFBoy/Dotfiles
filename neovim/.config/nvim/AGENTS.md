# AGENTS.md — Neovim config

Guidance for AI agents working in this Neovim configuration.

## What this is

A personal, **microkernel-style** Neovim config (Neovim **0.12+**). A `core/`
provides shared mechanisms (LSP keymaps, completion, formatter/linter/DAP
registries, options, keymaps) and per-language **driver** files register into
those shared services when their filetype opens.

**No lazy.nvim or any third-party plugin manager.** Everything runs on Neovim's
native `vim.pack` plugin manager (lockfile: `nvim-pack-lock.json`).

## How things load

`init.lua` requires the core modules once at startup, in the order listed
there (the only ordering constraint that matters is the `mapleader` gotcha
below).

Language drivers load **on demand**: Neovim's built-in `ftplugin/<lang>.lua`
runtime files fire automatically when a buffer of that filetype opens. Each one
is a single `require("lang.<name>")`; Lua's module cache (`package.loaded`)
guarantees `lua/lang/<name>.lua` executes only once per session no matter how
many buffers of that type are opened. No manual autocmds for this.

## File structure

```
init.lua
ftplugin/<lang>.lua     -- one-liner: require("lang.<lang>")
lua/
├── core/
│   ├── pack.lua         -- ALL plugins, one place (vim.pack.add)
│   ├── navigation.lua   -- fzf-lua + oil.nvim
│   ├── mason.lua        -- mason.nvim + ensure() helper; prepends mason/bin to PATH
│   ├── config.lua       -- vim.o options + diagnostic config
│   ├── theme.lua        -- neopywal.nvim colorscheme (pywal palette)
│   ├── autocomplete.lua -- blink.cmp + LuaSnip + friendly-snippets
│   ├── lsp.lua          -- shared LSP capabilities + LspAttach keymaps (fzf-lua)
│   ├── format.lua       -- conform.nvim + formatters registry
│   ├── lint.lua         -- nvim-lint + linters registry
│   ├── keymaps.lua      -- global keymaps (leader = SPACE, localleader = \)
│   ├── git.lua          -- gitsigns.nvim
│   ├── ui.lua           -- lualine, web-devicons, autopairs, tree-sitter-manager
│   └── dap.lua          -- nvim-dap + dap-ui + mason-nvim-dap + DAP registry + target helpers
└── lang/
    └── <name>.lua       -- per-language driver
```

## The driver pattern

A `lua/lang/<name>.lua` file, in order:

1. `require("core.mason").ensure("<server>")` (and formatters/linters) —
   installs the Mason package if missing; safe to call every load.
2. `require("core.format").register("<ft>", "<formatter>")` — conform registry.
3. `require("core.lint").register("<ft>", "<linter>")` — nvim-lint registry.
4. `vim.lsp.config("<name>", {...})` then `vim.lsp.enable("<name>")`.
5. Optionally `require("core.dap").register("<ft>", { mason=, name=, adapter=, configurations= })`.

See `lua/lang/c.lua` (minimal) and `lua/lang/csharp.lua` (full, with a DAP
adapter).

### Registries

`core/format.lua` and `core/lint.lua` expose `register(filetype, names)` which
write into `conform.formatters_by_ft` / `lint.linters_by_ft` — plain tables read
lazily at format/lint time, so late registration from ftplugins works without
re-setup. Formatting runs on save (`format_on_save`, LSP formatting as
fallback); linting runs on `BufWritePost` + `InsertLeave`.

### DAP

Read `core/dap.lua` before writing a DAP driver — its annotations and comments
document the `register()` API, adapter keying, and the target-discovery
helpers (`pick`, `offer_build`, the `ABORT` convention). `lang/csharp.lua` and
`lang/rust.lua` are complete examples.

## Conventions

- **Tabs** for indentation; run `stylua .` before committing (root
  `.stylua.toml`).
- All plugins go in `core/pack.lua` — one `vim.pack.add`, one place. Drivers
  must never call `vim.pack.add`: they run mid-FileType-event, after Neovim's
  ftplugin pass already scanned the runtimepath, so a plugin added there could
  never ship its own ftplugin (e.g. `rustaceanvim`).
- Keep per-language behavior (settings, formatter, linter, DAP) in the lang
  driver — don't spread it across core files. Core files stay language-agnostic.
- Mason binaries land in `~/.local/share/nvim/mason/bin` (prepended to PATH in
  `core/mason.lua`); reference them by bare name.
- Colorscheme is **neopywal.nvim** (`core/theme.lua`): it reads the pywal
  palette from `~/.cache/wal` (generated from the current wallpaper by the
  wallpaper switcher) and live-reloads when pywal regenerates colors. Always
  load `colorscheme neopywal-dark` — the plain `neopywal` name auto-detects the
  variant from `vim.o.background`, which can invert a pywal-generated palette.
  String literals are overridden to IntelliJ-style green (`#6a8759`) via
  `custom_highlights` — extend that table for more group tweaks.
- No emoji icons anywhere — Nerd Font glyphs only (Ghostty uses
  JetBrainsMono Nerd Font).
- neopywal's built-in `dap`/`dap_ui` highlight sets are **off by default**;
  they're enabled and re-coloured in `core/theme.lua` (pywal lacks
  `C.ok/warn/error` keys; the panel surface gets a hand-blended lifted
  background since `nvim_set_hl` can't take alpha).

## Governance
- Modules that expose an API follow the **Lua module pattern**: `local M = {}`
  at the top, functions added as `function M.name()`, and `return M` at the
  end (see `core/dap.lua`, `core/format.lua`, `core/lint.lua`). New functions
  go on `M` — never as globals. Side-effect-only modules (options, keymaps,
  setup) return nothing.
- You are not allowed to modify the core unless you get an explicit yes. Try
  to use as much of what the core exposes as possible before asking to add
  something new to the core.
- You are not allowed to modify anything outside the neovim config.
- You should always retrive the latest information/documentation from the web before editing or making a decision.

## Verification

Opening a file of the target filetype in a real session is the only way to
verify LSP/DAP/Mason wiring end to end (`:Mason` for package state). Static
checks (`nvim --headless -c 'qa'`, `stylua --check .`) live in the root
`AGENTS.md`.

## Gotchas

- `mapleader`/`maplocalleader` are set at the top of `init.lua` — **before**
  `core.navigation`, which maps `<leader>` keys at startup. Moving them back
  into `core/keymaps.lua` silently breaks every early `<leader>` mapping.
- `mason.ensure()` guards with `registry.has_package()` because requiring
  `mason-registry` triggers package indexing that may not be ready at load time.
