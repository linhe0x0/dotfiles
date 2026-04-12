return {
  {
    'danymat/neogen',
    event = 'VeryLazy',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    keys = {
      {
        '<leader>ng',
        ":lua require('neogen').generate()<CR>",
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Generate documentation',
      },
      {
        '<leader>nf',
        ":lua require('neogen').generate({ type = 'func' })<CR>",
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Generate function doc',
      },
      {
        '<leader>nc',
        ":lua require('neogen').generate({ type = 'class' })<CR>",
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Generate class doc',
      },
      {
        '<leader>nt',
        ":lua require('neogen').generate({ type = 'type' })<CR>",
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Generate type doc',
      },
      {
        '<C-h>',
        function()
          require('neogen').jump_prev()
        end,
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Previous doc placeholder',
      },
      {
        '<C-l>',
        function()
          require('neogen').jump_next()
        end,
        mode = 'n',
        noremap = true,
        silent = true,
        desc = 'Next doc placeholder',
      },
    },
    config = function()
      require('neogen').setup({
        snippet_engine = 'luasnip',
      })
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'typescriptreact', 'javascriptreact', 'vue', 'svelte', 'xml' },
    opts = {},
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
    opts = {
      enable_autocmd = false,
    },
  },
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      require('mini.comment').setup({
        options = {
          ignore_blank_line = true,
          start_of_line = false,
          custom_commentstring = function()
            return require('ts_context_commentstring.internal').calculate_commentstring()
              or vim.bo.commentstring
          end,
        },
        mappings = {
          comment = 'gc',
          comment_line = 'gcc',
          comment_visual = 'gc',
          textobject = 'gc',
        },
        keys = {
          { '<leader>c', 'gcc', desc = 'Toggle comment on current line', remap = true },
        },
      })

      require('mini.surround').setup({
        mappings = {
          add = 'gsa',
          delete = 'gsd',
          find = 'gsf',
          find_left = 'gsF',
          highlight = 'gsh',
          replace = 'gsr',
          update_n_lines = 'gsn',
          suffix_last = 'l',
          suffix_next = 'n',
        },
      })

      require('mini.pairs').setup()
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
  },
}
