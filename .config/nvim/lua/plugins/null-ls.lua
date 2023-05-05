local M = {
	"jose-elias-alvarez/null-ls.nvim",
}

function M.config()
	local nls = require("null-ls")
	nls.setup({
		debounce = 150,
		save_after_format = false,
		sources = {
			nls.builtins.formatting.stylua,
			nls.builtins.formatting.fish_indent,
			nls.builtins.diagnostics.shellcheck,
			nls.builtins.formatting.shfmt,
			nls.builtins.diagnostics.markdownlint,
			nls.builtins.diagnostics.luacheck,
			nls.builtins.formatting.prettierd.with({
				filetypes = { "markdown" }, -- only runs `deno fmt` for markdown
			}),
			-- nls.builtins.code_actions.gitsigns,
			nls.builtins.formatting.black,
			nls.builtins.diagnostics.flake8,
		},
		root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git"),

		-- auto_formatting for null-ls sources
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({
							bufnr = bufnr,
							filter = function(client)
								return client.name == "null-ls"
							end,
						})
					end,
				})
			end
		end,
	})
end

return M
