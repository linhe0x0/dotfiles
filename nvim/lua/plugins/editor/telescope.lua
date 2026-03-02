return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
    },
    keys = {
      {
        '<C-p>',
        '<cmd>Telescope find_files<cr>',
        desc = 'Find Files (root dir)',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>ff',
        '<cmd>Telescope find_files<cr>',
        desc = 'Find Files (root dir)',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>/',
        '<cmd>Telescope live_grep<cr>',
        desc = 'Grep (root dir)',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>fg',
        '<cmd>Telescope live_grep<cr>',
        desc = 'Grep (root dir)',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>fb',
        '<cmd>Telescope buffers<cr>',
        desc = 'Buffers',
        mode = 'n',
        silent = true,
        noremap = true,
      },
      {
        '<leader>fh',
        '<cmd>Telescope help_tags<cr>',
        desc = 'Help Pages',
        mode = 'n',
        silent = true,
        noremap = true,
      },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local fb_actions = require('telescope').extensions.file_browser.actions

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<C-o>'] = actions.select_default,
              ['<C-s>'] = actions.select_horizontal,
              ['<C-x>'] = actions.select_horizontal,
              ['<C-v>'] = actions.select_vertical,
              ['<C-t>'] = actions.select_tab,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
            n = {
              ['o'] = actions.select_default,
              ['s'] = actions.select_horizontal,
              ['x'] = actions.select_horizontal,
              ['v'] = actions.select_vertical,
              ['t'] = actions.select_tab,
              ['k'] = actions.move_selection_previous,
              ['j'] = actions.move_selection_next,
              ['q'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
        extensions = {
          file_browser = {
            hijack_netrw = true,
            mappings = {
              ['i'] = {
                ['<C-o>'] = actions.select_default,
                ['<C-s>'] = actions.select_horizontal,
                ['<C-x>'] = actions.select_horizontal,
                ['<C-v>'] = actions.select_vertical,
                ['<C-t>'] = actions.select_tab,
                ['<C-c>'] = fb_actions.create,
                ['<Tab>'] = fb_actions.change_cwd,
              },
              ['n'] = {
                ['o'] = actions.select_default,
                ['s'] = actions.select_horizontal,
                ['x'] = actions.select_horizontal,
                ['v'] = actions.select_vertical,
                ['t'] = actions.select_tab,
                ['<Tab>'] = fb_actions.change_cwd,
                ['c'] = fb_actions.create,
                ['p'] = fb_actions.goto_parent_dir,
                ['/'] = function()
                  vim.cmd.startinsert()
                end,
                ['<C-u>'] = function(prompt_bufnr)
                  for i = 1, 10 do
                    actions.move_selection_previous(prompt_bufnr)
                  end
                end,
                ['<C-d>'] = function(prompt_bufnr)
                  for i = 1, 10 do
                    actions.move_selection_next(prompt_bufnr)
                  end
                end,
                ['<PageUp>'] = actions.preview_scrolling_up,
                ['<PageDown>'] = actions.preview_scrolling_down,
              },
            },
          },
        },
      })

      telescope.load_extension('file_browser')
    end,
  },
  {
    'nvim-telescope/telescope-file-browser.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    keys = {
      {
        '<leader>fe',
        '<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>',
        mode = 'n',
        silent = true,
        noremap = true,
      },
    },
  },
}
