local M = {}
lvim.keys.normal_mode["tu"] = "<cmd>lua require('harpoon.term').gotoTerminal(1)<CR>"
lvim.keys.normal_mode["te"] = "<cmd>lua require('harpoon.term').gotoTerminal(2)<CR>"
lvim.keys.normal_mode["cu"] = "<cmd>lua require('harpoon.term').sendCommand(1, 1)<CR>"
lvim.keys.normal_mode["ce"] = "<cmd>lua require('harpoon.term').sendCommand(1, 2)<CR>"
lvim.keys.normal_mode["<M-Space>"] = "<cmd>lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>"
lvim.keys.normal_mode["mh"] = "<cmd>lua require('harpoon.mark').add_file()<cr>"

M.plugin = {
  "ThePrimeagen/harpoon",
  requires = "nvim-lua/plenary.nvim",
  after = { "telescope.nvim", "which-key.nvim" },
  config = function()
    require("telescope").load_extension "harpoon"

    local whk_status, whk = pcall(require, "which-key")
    if not whk_status then
      vim.notify("Could not load which key for harpoon", vim.log.levels.WARN)
      return
    end
    whk.register {
      ["<leader>1"] = { "<CMD>lua require('harpoon.ui').nav_file(1)<CR>", " goto1" },
      ["<leader>2"] = { "<CMD>lua require('harpoon.ui').nav_file(2)<CR>", " goto2" },
      ["<leader>3"] = { "<CMD>lua require('harpoon.ui').nav_file(3)<CR>", " goto3" },
      ["<leader>4"] = { "<CMD>lua require('harpoon.ui').nav_file(4)<CR>", " goto4" },
      ["<leader>a"] = { "<cmd>lua require('harpoon.mark').add_file()<CR>", " Add Mark" },
      ["<leader>0"] = { "<cmd>Telescope harpoon marks<CR>", " Harpoon" },
    }
  end,
}

return M
