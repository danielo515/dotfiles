vim.o.guifont = "FontAwesome:h13:antialias=true:autocmd=false"
-- vim.o.guifont = "MonoLisa:h9:antialias=true:autocmd=false"
-- vim.o.emoji_font = "MonoLisa:h9:antialias=true:autocmd=false"
vim.o.background = "dark"
vim.g.colors_name = "nord"

-- vim.opt.guifont = "Roboto Mono Bold:h10"
-- vim.opt.guifont = "Pine:h10"

-- vim.cmd [[
--   set linespace=15
-- ]]

vim.g.neovide_fullscreen = false
-- vim.g.neovide_transparency = 0.5

-- Takes up a bit of memory
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_vfx_mode = "railgun" -- Available modes [pixiedust, sonicboom, railgun, torpedo, ripple, wireframe]
-- vim.g.neovide_cursor_vfx_particle_lifetime = 10
-- vim.g.neovide_cursor_vfx_particle_density = 20
-- vim.g.neovide_cursor_vfx_particle_phase = 6.5
-- vim.g.neovide_cursor_vfx_particle_speed = 3.0

-- Takes up a lot of memory
-- vim.g.neovide_no_idle = true
-- vim.g.neovide_refresh_rate = 140

-- Neovide Specific Settings
vim.g.gitblame_enabled = 1
vim.g.gitblame_highlight_group = "gitblame"
vim.g.gitblame_message_template = "by %a on %d at %H:%M:%S"
