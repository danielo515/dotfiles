local NOREF_NOERR_TRUNC = { noremap = true, silent = true, nowait = true }
return {
  'nyngwang/NeoZoom.lua',
  -- branch = 'neo-zoom-original', -- UNCOMMENT THIS, if you prefer the old one
  config = function()
    require('neo-zoom').setup { -- use the defaults or UNCOMMENT and change any one to overwrite
      -- left_ratio = 0.2,
      -- top_ratio = 0.03,
      -- width_ratio = 0.67,
      -- height_ratio = 0.9,
      -- border = 'double',
    }
    vim.keymap.set('n', '<CR>', function()
      vim.cmd('NeoZoomToggle')
    end, NOREF_NOERR_TRUNC)
  end
}
