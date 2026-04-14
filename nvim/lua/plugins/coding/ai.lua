return {
  {
    'zbirenbaum/copilot.lua',
    event = { 'BufReadPost' },
    cmd = 'Copilot',
    config = function()
      require('copilot').setup({
        nes = {
          enabled = false,
        },
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = false,
          keymap = {
            accept = '<C-\\>',
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-]>',
          },
        },
        should_attach = function(_, bufname)
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
            return false
          end

          return true
        end,
      })
    end,
  },
  {
    'folke/sidekick.nvim',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile', 'VeryLazy' },
    opts = {
      cli = {
        mux = {
          backend = 'tmux',
          enabled = true,
          create = 'split',
        },
        split = {
          vertical = true, -- vertical or horizontal split
          size = 0.5, -- size of the split (0-1 for percentage)
        },
        win = {
          split = {
            width = 0, -- set to 0 for default split width
            height = 0, -- set to 0 for default split width
          },
        },
      },
    },
    keys = {
      {
        '<tab>',
        function()
          local sidekick = require('sidekick')

          if sidekick.nes_jump_or_apply() then
            return
          end

          return '<Tab>'
        end,
        mode = { 'n' },
        expr = true,
        desc = 'Goto/Apply Next Edit Suggestion',
      },
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle()
        end,
        desc = 'Sidekick Toggle CLI',
      },
      {
        '<leader>as',
        function()
          require('sidekick.cli').select({
            filter = {
              installed = true,
            },
          })
        end,
        desc = 'Select CLI',
      },
      {
        '<leader>ad',
        function()
          require('sidekick.cli').close()
        end,
        desc = 'Detach a CLI Session',
      },
      {
        '<leader>at',
        function()
          require('sidekick.cli').send({ msg = '{this}' })
        end,
        mode = { 'x', 'n' },
        desc = 'Send This',
      },
      {
        '<leader>af',
        function()
          require('sidekick.cli').send({ msg = '{file}' })
        end,
        desc = 'Send File',
      },
      {
        '<leader>av',
        function()
          require('sidekick.cli').send({ msg = '{selection}' })
        end,
        mode = { 'x' },
        desc = 'Send Visual Selection',
      },
      {
        '<leader>ap',
        function()
          require('sidekick.cli').prompt()
        end,
        mode = { 'n', 'x' },
        desc = 'Sidekick Select Prompt',
      },
      {
        '<leader>ac',
        function()
          require('sidekick.cli').toggle({ name = 'claude', focus = true })
        end,
        desc = 'Sidekick Toggle Claude',
      },
      {
        '<leader>ao',
        function()
          require('sidekick.cli').toggle({ name = 'opencode', focus = true })
        end,
        desc = 'Sidekick Toggle OpenCode',
      },
    },
  },
}
