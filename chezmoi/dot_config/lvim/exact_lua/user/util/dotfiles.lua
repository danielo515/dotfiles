local ch = require("user.util.chezmoi")

local dotfiles = {
  path = ch.has_chezmoi and ch.get_chezmoi_dir() or vim.fn.environ()["DOTFILES"],
}

return dotfiles
