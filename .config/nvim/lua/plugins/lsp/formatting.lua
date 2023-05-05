local util = require("util")

local M = {}

M.autoformat = true

function M.toggle()
	M.autoformat = not M.autoformat
	if M.autoformat then
		util.info("enabled format on save", "Formatting")
	else
		util.warn("disabled format on save", "Formatting")
	end
end

function M.auto_format()
	if M.autoformat then
		if vim.lsp.buf.format then
			vim.lsp.buf.format()
		end
	end
end

function M.format()
	if vim.lsp.buf.format then
		vim.lsp.buf.format()
	end
end

function M.setup(client, buf)
	-- format on save
	if client.server_capabilities.documentFormattingProvider then
		vim.cmd([[
      augroup LspFormat
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua require("plugins.lsp.formatting").auto_format()
      augroup END
    ]])
	end
end

return M
