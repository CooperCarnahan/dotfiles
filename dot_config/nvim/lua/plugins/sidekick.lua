return {
	"folke/sidekick.nvim",
	opts = {
		cli = {
			win = {
				float = {
					title = "",
				},
				split = {
					width = 100,
				},
			},
			mux = {
				backend = "zellij",
				enabled = true,
			},
			tools = {
				omp = {
					cmd = { "omp" },
				},
			},
		},
	},
}
