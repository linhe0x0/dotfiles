return {
  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    keys = {
      {
        '<C-p>',
        '<cmd>FzfLua files<cr>',
        desc = 'Find Files (root dir)',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>ff',
        '<cmd>FzfLua files<cr>',
        desc = 'Find Files (root dir)',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>/',
        '<cmd>FzfLua live_grep<cr>',
        desc = 'Grep (root dir)',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>fg',
        '<cmd>FzfLua live_grep<cr>',
        desc = 'Grep (root dir)',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>fb',
        '<cmd>FzfLua buffers<cr>',
        desc = 'Buffers',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>fh',
        '<cmd>FzfLua helptags<cr>',
        desc = 'Help Pages',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>fe',
        '<cmd>FzfLua files cwd=%:p:h<cr>',
        desc = 'File Browser',
        mode = 'n',
        silent = true,
        noremap = true,
      },
    },
    opts = function()
      local actions = require('fzf-lua.actions')

      return {
        'default-title',
        fzf_colors = {
          bg = { 'bg', 'Normal' },
          gutter = { 'bg', 'Normal' },
          preview_bg = { 'bg', 'Normal' },
          preview_border = { 'bg', 'Normal' },
          scrollbar = { 'bg', 'Normal' },
          separator = { 'fg', 'Comment' },
          border = { 'fg', 'Comment' },
        },
        winopts = {
          border = 'rounded',
          preview = {
            border = 'rounded',
            scrollbar = 'float',
          },
        },
        keymap = {
          builtin = {
            ['<C-k>'] = 'preview-page-up',
            ['<C-j>'] = 'preview-page-down',
          },
          fzf = {
            ['ctrl-k'] = 'up',
            ['ctrl-j'] = 'down',
            ['ctrl-o'] = 'accept',
            ['ctrl-s'] = 'accept',
            ['ctrl-x'] = 'accept',
            ['ctrl-v'] = 'accept',
            ['ctrl-t'] = 'accept',
            ['ctrl-q'] = 'select-all+accept',
          },
        },
        actions = {
          files = {
            ['default'] = actions.file_edit_or_qf,
            ['ctrl-s'] = actions.file_split,
            ['ctrl-x'] = actions.file_split,
            ['ctrl-v'] = actions.file_vsplit,
            ['ctrl-t'] = actions.file_tabedit,
            ['ctrl-q'] = actions.file_sel_to_qf,
          },
        },
      }
    end,
    config = function(_, opts)
      require('fzf-lua').setup(opts)
    end,
  },
}
