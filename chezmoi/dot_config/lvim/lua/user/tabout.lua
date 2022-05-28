local function tab(fallback)
	local methods = require("lvim.core.cmp").methods
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expandable() then
		luasnip.expand()
	elseif methods.jumpable() then
		luasnip.jump(1)
	elseif methods.check_backspace() then
		fallback()
	else
		print("not working at all")
		require("tabout").tabout()
	end
end

local cmp = require("cmp")
lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(tab, { "i", "s" })

return {
	"abecodes/tabout.nvim",
	config = function()
		require("tabout").setup({
			tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
			backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
			act_as_tab = true, -- shift content if tab out is not possible
			act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
			-- default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
			default_shift_tab = "<C-d>", -- reverse shift default action,
			enable_backwards = true, -- well ...
			completion = true, -- if the tabkey is used in a completion pum
			ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
			tabouts = {
				{ open = "'", close = "'" },
				{ open = '"', close = '"' },
				{ open = "`", close = "`" },
				{ open = "(", close = ")" },
				{ open = "[", close = "]" },
				{ open = "{", close = "}" },
			},
			exclude = { "TelescopePrompt" }, -- tabout will ignore these filetypes
		})
	end,
	wants = { "nvim-treesitter" }, -- or require if not used so far
	-- after = { "nvim-cmp" }, -- if a completion plugin is using tabs load it before
}
