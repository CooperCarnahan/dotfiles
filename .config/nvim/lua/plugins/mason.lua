local M = {
	"jay-babu/mason-null-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"williamboman/mason.nvim",
		"jose-elias-alvarez/null-ls.nvim",
	},
}

function M.config()
	require("mason").setup()
	require("mason-null-ls").setup({
		ensure_installed = { "stylua", "shfmt", "black" },
		automatic_setup = true,
		handlers = {
			function() end,
			stylua = function(source_name, methods)
				require("mason-null-ls").default_setup(source_name, methods)
			end,
			shfmt = function(source_name, methods)
				require("mason-null-ls").default_setup(source_name, methods)
			end,
			black = function(source_name, methods)
				require("mason-null-ls").default_setup(source_name, methods)
			end,
		},
	})
	require("mason-lspconfig").setup({
		automatic_installation = true,
	})
end

return M
