return {
  {
    'utilyre/barbecue.nvim',
    event = 'BufReadPost',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('barbecue').setup({
        attach_navic = false,
      })
    end,
  },
}
