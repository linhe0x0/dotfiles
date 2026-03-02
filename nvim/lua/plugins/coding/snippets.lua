return {
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'nvim-cmp',
    },
    opts = {
      delete_check_events = 'TextChanged',
    },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
  {
    'rafamadriz/friendly-snippets',
    lazy = true,
  },
}
