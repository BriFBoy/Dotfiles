local function setup_conform(languages)
  local formatters_by_ft = {}

  for ft, lang in pairs(languages) do
    if lang.formatter then
      formatters_by_ft[ft] = { lang.formatter }
    end
  end

  require("conform").setup({
    formatters_by_ft = formatters_by_ft,
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
  })
end

setup_conform(require("language"))
