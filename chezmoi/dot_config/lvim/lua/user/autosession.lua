return {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({
			log_level = "debug",
			auto_session_enable_last_session = false,
			auto_session_suppress_dirs = { "~/" },
		})
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
	end,
}
