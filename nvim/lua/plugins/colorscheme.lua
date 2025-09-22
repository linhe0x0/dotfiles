return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("solarized-osaka").setup({
				transparent = true,
				terminal_colors = true,
				dim_inactive = true,
				lualine_bold = true,
				styles = {
					comments = {
						italic = true,
					},
					keywords = {
						bold = true,
						italic = false,
					},
					functions = {},
					variables = {},
					sidebars = "dark",
					floats = "dark",
				},
			})

			vim.cmd.colorscheme("solarized-osaka")
		end,
	},
}
