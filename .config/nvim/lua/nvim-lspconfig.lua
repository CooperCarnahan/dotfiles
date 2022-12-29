-- Setup lspconfig.
local nvim_lsp = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
local opts = { noremap = true, silent = true }

local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local nmap = function(map, cmd, opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", map, "<cmd>lua " .. cmd .. "<cr>", opts)
	end
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	nmap("gD", "vim.lsp.buf.declaration()", opts)
	nmap("gd", "vim.lsp.buf.definition()", opts)
	nmap("gi", "vim.lsp.buf.implementation()", opts)
	nmap("<space>wa", "vim.lsp.buf.add_workspace_folder()", opts)
	nmap("<space>wr", "vim.lsp.buf.remove_workspace_folder()", opts)
	nmap("<space>wl", "print(vim.inspect(vim.lsp.buf.list_workspace_folders()))", opts)
	nmap("<space>D", " vim.lsp.buf.type_definition()", opts)
	nmap("<space>ca", "vim.lsp.buf.code_action()", opts)
end

local servers = { "pyright", "rust_analyzer", "clangd", "sumneko_lua", "dartls", "gopls" }
for _, lsp in pairs(servers) do
	require("lspconfig")[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- require('rust-tools').setup({on_attach = on_attach})
