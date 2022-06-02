local has_chezmoi = vim.fn.executable "chezmoi" == 1

local function get_chezmoi_dir()
  local results = vim.fn.execute "!chezmoi source-path"
  local results_split = vim.split(results, "\n", { trimempty = true })
  local path = results_split[3]
  vim.notify("Using " .. path .. " as chezmoi path", vim.log.levels.DEBUG, { title = "Danielo" })
  return path
end

local dotfiles = {
  path = has_chezmoi and get_chezmoi_dir() or vim.fn.environ()["DOTFILES"],
}

return dotfiles
