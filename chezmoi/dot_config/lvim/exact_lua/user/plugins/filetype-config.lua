return {
  "nathom/filetype.nvim",
  config = function()
    require("filetype").setup {
      overrides = {
        literal = {
          ["kitty.conf"] = "kitty",
          [".gitignore"] = "conf",
        },
        complex = {
          [".clang*"] = "yaml",
          [".*%.env.*"] = "sh",
          [".*ignore"] = "conf",
        },
        extensions = {
          zsh = "bash", -- used for zsh configuration files
          tf = "terraform",
          tfvars = "terraform",
          hcl = "hcl",
          tfstate = "json",
          eslintrc = "json",
          prettierrc = "json",
          mdx = "markdown",
          re = "reason",
        },
      },
    }
  end,
}
