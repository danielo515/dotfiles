local bind = require("user.util").bind
-- Syntax Tree Surfer V2 Mappings
-- Targeted Jump with virtual_text
local stf = require("syntax-tree-surfer")
-- vim.keymap.set("n", "gv", function() -- only jump to variable_declarations
-- 	stf.targeted_jump({ "variable_declaration" })
-- end, opts)
-- vim.keymap.set("n", "gfu", function() -- only jump to functions
-- 	stf.targeted_jump({ "function" })
-- end, opts)
-- vim.keymap.set("n", "gif", function() -- only jump to if_statements
-- 	stf.targeted_jump({ "if_statement" })
-- end, opts)
-- vim.keymap.set("n", "gfo", function() -- only jump to for_statements
-- 	stf.targeted_jump({ "for_statement" })
-- end, opts)
vim.keymap.set("n", "gj", function() -- jump to all that you specify
	stf.targeted_jump({
		"function",
		"if_statement",
		"else_clause",
		"else_statement",
		"elseif_statement",
		"for_statement",
		"while_statement",
		"switch_statement",
		"variable_declaration",
		"arguments",
	})
end, { desc = "Jump to lps nodes" })

-------------------------------
-- filtered_jump --
-- "default" means that you jump to the default_desired_types or your lastest jump types
vim.keymap.set("n", "<A-n>", bind(stf.filtered_jump, "default", true), { desc = "jump to next of latest search" }) --> true means jump forward
vim.keymap.set("n", "<A-p>", bind(stf.filtered_jump, "default", false), { desc = "jump to previous of latest search" }) --> false means jump backwards

-- -- non-default jump --> custom desired_types
-- vim.keymap.set("n", "your_keymap", function()
-- 	stf.filtered_jump({
-- 		"if_statement",
-- 		"else_clause",
-- 		"else_statement",
-- 	}, true) --> true means jump forward
-- end, opts)
-- vim.keymap.set("n", "your_keymap", function()
-- 	stf.filtered_jump({
-- 		"if_statement",
-- 		"else_clause",
-- 		"else_statement",
-- 	}, false) --> false means jump backwards
-- end, opts)

-------------------------------
-- jump with limited targets --
-- jump to sibling nodes only
-- vim.keymap.set("n", "-", function()
-- 	stf.filtered_jump({
-- 		"if_statement",
-- 		"else_clause",
-- 		"else_statement",
-- 	}, false, { destination = "siblings" })
-- end, opts)
-- Testing
vim.keymap.set("n", "gk", bind(stf.surf, "next", "visual"), { desc = "Surf!" })

vim.keymap.set("n", "=", function()
	stf.filtered_jump({ "if_statement", "else_clause", "else_statement" }, true, { destination = "siblings" })
end, { desc = "jump to siblings" })

-- jump to parent or child nodes only
vim.keymap.set("n", "_", function()
	stf.filtered_jump({
		"if_statement",
		"else_clause",
		"else_statement",
	}, false, { destination = "parent" })
end, { desc = "jump to parent nodes" })
vim.keymap.set("n", "+", function()
	stf.filtered_jump({
		"if_statement",
		"else_clause",
		"else_statement",
	}, true, { destination = "children" })
end, { desc = "jump to child nodes" })

-- Setup Function example:
-- These are the default options:
require("syntax-tree-surfer").setup({
	highlight_group = "STS_highlight",
	disable_no_instance_found_report = false,
	default_desired_types = {
		"function",
		"if_statement",
		"else_clause",
		"else_statement",
		"elseif_statement",
		"for_statement",
		"while_statement",
		"switch_statement",
	},
	left_hand_side = "fdsawervcxqtzb",
	right_hand_side = "jkl;oiu.,mpy/n",
	icon_dictionary = {
		["if_statement"] = "",
		["else_clause"] = "",
		["else_statement"] = "",
		["elseif_statement"] = "",
		["for_statement"] = "ﭜ",
		["while_statement"] = "ﯩ",
		["switch_statement"] = "ﳟ",
		["function"] = "",
		["variable_declaration"] = "",
	},
})
