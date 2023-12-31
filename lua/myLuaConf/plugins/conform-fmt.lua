require("conform").setup({
  formatters_by_ft = {
    nix = { "nixfmt" },
    -- csharp = { "uncrustify" },
  },
  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
})

