vim.filetype.add {
  extension = {
    zsh = "bash", -- used for zsh configuration files
    sh = "bash",
    tf = "terraform",
    tfvars = "terraform",
    hcl = "hcl",
    tfstate = "json",
    eslintrc = "json",
    prettierrc = "json",
    mdx = "markdown",
    re = "reason",
    rei = "reason",
  },
  filename = {
    ["kitty.conf"] = "kitty",
  },
  pattern = {
    [".*/etc/foo/.*"] = "fooscript",
  },
}
