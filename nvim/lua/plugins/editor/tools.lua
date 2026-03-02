return {
  {
    'smjonas/inc-rename.nvim',
    event = 'VeryLazy',
    cmd = 'IncRename',
    config = true,
  },
  {
    'junegunn/vim-easy-align',
    event = 'VeryLazy',
    cmd = 'EasyAlign',
    keys = {
      { 'ga', '<Plug>(EasyAlign)', mode = 'n', silent = true, noremap = false },
      { 'ga', '<Plug>(EasyAlign)', mode = 'x', silent = true, noremap = false },
    },
  },
}
