return {
  {
    'folke/trouble.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = { use_diagnostic_signs = true },
    keys = {
      {
        '<leader>xx',
        '<cmd>TroubleToggle<cr>',
        desc = 'Diagnostics (Troble)',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>xw',
        '<cmd>TroubleToggle workspace_diagnostics<cr>',
        desc = 'Workspace Diagnostics (Trouble)',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>xd',
        '<cmd>TroubleToggle document_diagnostics<cr>',
        desc = 'Document Diagnostics (Trouble)',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>xl',
        '<cmd>TroubleToggle loclist<cr>',
        desc = 'Location List (Trouble)',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>xq',
        '<cmd>TroubleToggle quickfix<cr>',
        desc = 'Quickfix List (Trouble)',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '[e',
        function()
          if require('trouble').is_open() then
            require('trouble').previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Previous trouble/quickfix item',
      },
      {
        ']e',
        function()
          if require('trouble').is_open() then
            require('trouble').next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Next trouble/quickfix item',
      },
    },
  },
}
