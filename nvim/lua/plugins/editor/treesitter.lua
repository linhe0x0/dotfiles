return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
    priority = 900,
    config = function()
      require('nvim-treesitter').setup()

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_setup', { clear = true }),
        callback = function()
          pcall(vim.treesitter.start)
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
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = {
      enable = true,
      mode = 'cursor',
      max_lines = 3,
    },
  },
}
