return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      indent = {
        enabled = true,
        char = '│',
        only_scope = false,
        only_current = false,
      },
      scope = {
        enabled = true,
      },
      input = {
        enabled = true,
      },
    },
  },
}
