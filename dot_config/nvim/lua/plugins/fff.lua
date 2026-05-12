return {
	"dmtrKovalenko/fff.nvim",
	build = function()
		require("fff.download").download_or_build_binary()
	end,
	opts = {
		layout = {
			prompt_position = "top",
		},
		keymaps = {
			close = { "<Esc>", "<C-c>" },
		},
	},
	keys = {
		{
			"<C-p>",
			function()
				require("fff").find_files()
			end,
			desc = "Find Files (fff)",
		},
		{
			"<leader>sg",
			function()
				require("fff").live_grep({ cwd = vim.fn.getcwd() })
			end,
			desc = "Live Grep (cwd)",
		},
		{
			"<leader>sG",
			function()
				local root = vim.fs.root(0, ".git") or vim.fn.getcwd()
				require("fff").live_grep({ cwd = root })
			end,
			desc = "Live Grep (root)",
		},
	},
}
