-- Disable virtual text
lvim.lsp.diagnostics.virtual_text = false
lvim.builtin.which_key.mappings["gj"] = { "<cmd>lua require('lsp_lines').toggle()<cr>", "Toggle LSP lines" }
-- Configure the installation
return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  config = function()
    require("lsp_lines").setup()
  end,
}
