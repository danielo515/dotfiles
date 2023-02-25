package plugins;

import vim.plugin.types.VimPlugin;

@:expose('setup_copilot') @:keep
function setup_copilot() {
	final x:Plugin<Copilot> = "copilot";
	x.call(copilot -> copilot.setup({
		panel: {
			enabled: true,
			auto_refresh: true,
			keymap: {
				jump_prev: "[[",
				jump_next: "]]",
				accept: "<CR>",
				refresh: "gr",
				open: "<M-CR>",
			},
			layout: {
				position: "bottom",
				ratio: 0.4,
			},
		},
		suggestion: {
			enabled: true,
			auto_trigger: true,
			debounce: 75,
			keymap: {
				accept: "<c-e>",
				accept_word: false,
				accept_line: false,
				next: "<M-b>",
				prev: "<M-v>",
				dismiss: "<C-c>",
			},
		},
		filetypes: {
			yaml: false,
			markdown: false,
			help: false,
			gitcommit: false,
			gitrebase: false,
			hgcommit: false,
			svn: false,
			cvs: false,
		},
		copilot_node_command: "node"
	}));
}
