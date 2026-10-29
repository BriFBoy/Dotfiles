-- Dockerfile + compose: dockerls, docker_compose_language_service, hadolint.

local mason = require("core.mason")

mason.ensure("dockerfile-language-server")
mason.ensure("docker-compose-language-service")
mason.ensure("hadolint")

require("core.lint").register("dockerfile", "hadolint")

vim.lsp.config("dockerls", {})
vim.lsp.enable("dockerls")

-- Only attaches to filetype "yaml.docker-compose", which Neovim doesn't
-- detect by itself.
vim.lsp.config("docker_compose_language_service", {})
vim.lsp.enable("docker_compose_language_service")
