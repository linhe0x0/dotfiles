vim.filetype.add({
	-- extension = { rasi = "rasi", rofi = "rasi", wofi = "rasi" },
	-- filename = {
	--   ["vifmrc"] = "vim",
	-- },
	pattern = {
		["%.env%.[%w_.-]+"] = "sh",
	},
})
