# Neovim config

Personal microkernel-style config for Neovim 0.12+. Using only the native `vim.pack` as the package manager.

## Dependencies

All LSP servers, formatters, linters, and DAP adapters install themselves via
[Mason](https://github.com/mason-org/mason.nvim) the first time a file of that
language is opened.

No manual installs required.

## Language toolchains (optional)

Only needed for the build/debug helpers in the DAP drivers, not for LSP:
`cargo` (Rust), `dotnet` SDK (C#).
