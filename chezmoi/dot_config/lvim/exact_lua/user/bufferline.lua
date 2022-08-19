local kind = require("user.lsp_kind")
local List = require("plenary.collections.py_list")

local g_ok, bufferline_groups = pcall(require, "bufferline.groups")
if not g_ok then
	bufferline_groups = { builtin = { ungroupued = { name = "ungrouped" } } }
end
lvim.builtin.bufferline.options.groups = {
	options = {
		toggle_hidden_on_enter = true,
	},
	items = {
		bufferline_groups.builtin.ungrouped,
		{
			highlight = { guisp = "#51AFEF" },
			name = "tests",
			icon = kind.icons.test,
			matcher = function(buf)
				return buf.filename:match("_spec") or buf.filename:match("test")
			end,
		},
		{
			name = "screens",
			icon = kind.icons.screen,
			matcher = function(buf)
				return buf.path:match("screen")
			end,
		},
		{
			highlight = { guisp = "#C678DD" },
			name = "docs",
			matcher = function(buf)
				local list = List({ "md", "org", "norg", "wiki" })
				return list:contains(vim.fn.fnamemodify(buf.path, ":e"))
			end,
		},
		{
			highlight = { guisp = "#F6A878" },
			name = "config",
			matcher = function(buf)
				return buf.filename:match("go.mod")
					or buf.filename:match("go.sum")
					or buf.filename:match("Cargo.toml")
					or buf.filename:match("manage.py")
					or buf.filename:match("Makefile")
					or buf.filename:match("package.json")
					or buf.filename:match("config.lua")
			end,
		},
	},
}
