return {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({
			auto_session_enable_last_session = false,
			auto_session_suppress_dirs = { "~/" },
			auto_session_use_git_branch = true,
		})
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
	end,
}
