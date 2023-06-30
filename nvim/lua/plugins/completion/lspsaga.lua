return {
  "glepnir/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    {"nvim-tree/nvim-web-devicons"},
    {"nvim-treesitter/nvim-treesitter"},
  },
  config = function()
    require("lspsaga").setup({})
  end,
}