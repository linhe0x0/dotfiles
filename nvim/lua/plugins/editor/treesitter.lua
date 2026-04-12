return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    priority = 900,
    config = function()
      require('nvim-treesitter').setup()

      require('nvim-treesitter').install({
        'bash',
        'css',
        'go',
        'html',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'vue',
        'yaml',
      })

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_setup', { clear = true }),
        callback = function()
          if pcall(vim.treesitter.start) then
            vim.bo.syntax = ''
          end
        end,
      })

      vim.keymap.set({ 'n', 'x' }, '<C-space>', function()
        vim.treesitter.incremental_selection.init_selection()
      end, { desc = 'Increment selection' })
      vim.keymap.set('x', '<bs>', function()
        vim.treesitter.incremental_selection.node_decremental()
      end, { desc = 'Decrement selection' })
      vim.keymap.set('x', '<C-space>', function()
        vim.treesitter.incremental_selection.node_incremental()
      end, { desc = 'Increment selection' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      local move = require('nvim-treesitter-textobjects.move')
      local select = require('nvim-treesitter-textobjects.select')
      local swap = require('nvim-treesitter-textobjects.swap')

      for name, fn in pairs(move) do
        if name:find('goto') == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local key = q == '@function.outer' and (name:find('next') and ']]' or '[[')
                or q == '@class.outer' and (name:find('next') and ']m' or '[m')
              if key then
                vim.cmd.normal({ key, bang = true })
                return
              end
            end
            return fn(q, ...)
          end
        end
      end

      vim.keymap.set({ 'x', 'o' }, 'af', function()
        select.select_textobject('@function.outer', 'textobjects')
      end, { desc = 'Select outer function' })
      vim.keymap.set({ 'x', 'o' }, 'if', function()
        select.select_textobject('@function.inner', 'textobjects')
      end, { desc = 'Select inner function' })
      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        select.select_textobject('@class.outer', 'textobjects')
      end, { desc = 'Select outer class' })
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        select.select_textobject('@class.inner', 'textobjects')
      end, { desc = 'Select inner class' })
      vim.keymap.set({ 'x', 'o' }, 'aa', function()
        select.select_textobject('@parameter.outer', 'textobjects')
      end, { desc = 'Select outer argument' })
      vim.keymap.set({ 'x', 'o' }, 'ia', function()
        select.select_textobject('@parameter.inner', 'textobjects')
      end, { desc = 'Select inner argument' })

      vim.keymap.set('n', '<leader>spa', function()
        swap.swap_next('@parameter.inner')
      end, { desc = 'Swap parameter with next' })
      vim.keymap.set('n', '<leader>spA', function()
        swap.swap_previous('@parameter.inner')
      end, { desc = 'Swap parameter with previous' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = {
      enable = true,
      mode = 'cursor',
      max_lines = 3,
      separator = '-',
      trim_scope = 'outer',
    },
  },
}
