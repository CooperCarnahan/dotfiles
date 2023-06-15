function OnAttach(client, bufnr)
	require("nvim-navic").attach(client, bufnr)
	require("plugins.lsp.formatting").setup(client, bufnr)
	require("plugins.lsp.keys").setup(client, bufnr)
end

local M = {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{
			"simrat39/rust-tools.nvim",
			config = function()
				local rt = require("rust-tools")

				rt.setup({
					server = {
						on_attach = function(client, bufnr)
							-- Hover actions
							vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
							-- Code action groups
							vim.keymap.set(
								"n",
								"<Leader>ca",
								rt.code_action_group.code_action_group,
								{ buffer = bufnr }
							)
							OnAttach(client, bufnr)
						end,
					},
				})
			end,
		},
	},
}

function M.config()
	require("mason")
	require("plugins.lsp.diagnostics").setup()

	---@type lspconfig.options
	local servers = {
		ansiblels = {},
		bashls = {},
		clangd = {},
		cmake = {},
		cssls = {},
		dockerls = {},
		tsserver = {},
		svelte = {},
		eslint = {},
		html = {},
		jsonls = {
			on_new_config = function(new_config)
				new_config.settings.json.schemas = new_config.settings.json.schemas or {}
				vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
			end,
			settings = {
				json = {
					format = {
						enable = true,
					},
					validate = { enable = true },
				},
			},
		},
		gopls = {},
		marksman = {},
		pyright = {},
		yamlls = {},
		sumneko_lua = {},
		-- tailwindcss = {},
	}

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	---@type _.lspconfig.options
	local options = {
		on_attach = OnAttach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
	}

	for server, opts in pairs(servers) do
		opts = vim.tbl_deep_extend("force", {}, options, opts or {})
		require("lspconfig")[server].setup(opts)
	end
end

return M
