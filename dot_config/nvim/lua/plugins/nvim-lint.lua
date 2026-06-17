-- cmake linting is intentionally disabled (low value for this project). The
-- LazyVim `lang.cmake` extra defaults nvim-lint to the standalone `cmakelint`;
-- override it to no linters so cmake files aren't linted in the editor.
-- (Formatting is handled by neocmakelsp -> gersemi; see nvim-lspconfig.lua.)
return {
	"mfussenegger/nvim-lint",
	opts = function(_, opts)
		opts.linters_by_ft = opts.linters_by_ft or {}
		opts.linters_by_ft.cmake = {}
	end,
}
