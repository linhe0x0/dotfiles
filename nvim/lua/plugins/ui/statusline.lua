return {
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    priority = 800,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus

      if vim.fn.argc(-1) > 0 then
        vim.o.statusline = ' '
      else
        vim.o.laststatus = 0
      end
    end,
    opts = {
      options = {
        theme = 'auto',
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },

        lualine_c = {
          {
            'filename',
            path = 1,
          },
          {
            'diagnostics',
            symbols = {
              error = require('constants.icons').diagnostics.Error,
              warn = require('constants.icons').diagnostics.Warn,
              info = require('constants.icons').diagnostics.Info,
              hint = require('constants.icons').diagnostics.Hint,
            },
          },
          { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
        },
        lualine_x = {
          {
            function()
              return require('noice').api.status.command.get()
            end,
            cond = function()
              return package.loaded['noice'] and require('noice').api.status.command.has()
            end,
          },
          {
            function()
              return require('noice').api.status.mode.get()
            end,
            cond = function()
              return package.loaded['noice'] and require('noice').api.status.mode.has()
            end,
          },
          {
            function()
              return '  ' .. require('dap').status()
            end,
            cond = function()
              return package.loaded['dap'] and require('dap').status() ~= ''
            end,
          },
          {
            require('lazy.status').updates,
            cond = require('lazy.status').has_updates,
          },
          {
            'diff',
            symbols = {
              added = require('constants.icons').git.added,
              modified = require('constants.icons').git.modified,
              removed = require('constants.icons').git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          {
            function()
              local icons = {
                Error = { '', 'DiagnosticError' },
                Inactive = { '', 'MsgArea' },
                Warning = { '', 'DiagnosticWarn' },
                Normal = { '', 'DiagnosticOk' },
              }

              local status = require('sidekick.status').get()
              return status and vim.tbl_get(icons, status.kind, 1)
            end,
            cond = function()
              return require('sidekick.status').get() ~= nil
            end,
            color = function()
              local icons = {
                Error = 'DiagnosticError',
                Inactive = 'MsgArea',
                Warning = 'DiagnosticWarn',
                Normal = 'DiagnosticOk',
              }

              local status = require('sidekick.status').get()
              local hl = status and (status.busy and 'DiagnosticWarn' or icons[status.kind])
              return { fg = Snacks.util.color(hl) }
            end,
          },
          {
            function()
              local status = require('sidekick.status').cli()
              return ' ' .. (#status > 1 and #status or '')
            end,
            cond = function()
              return #require('sidekick.status').cli() > 0
            end,
            color = function()
              return { fg = Snacks.util.color('Special') }
            end,
          },
        },
        lualine_y = {
          { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
          { 'location', padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return ' ' .. os.date('%R')
          end,
        },
      },
      extensions = { 'neo-tree', 'lazy' },
    },
  },
}
