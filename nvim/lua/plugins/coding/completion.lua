return {
  {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        dependencies = { 'rafamadriz/friendly-snippets' },
        opts = {
          delete_check_events = 'TextChanged',
        },
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
    },
    opts = {
      keymap = {
        preset = 'default',
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-d>'] = { 'scroll_documentation_down' },
        ['<C-f>'] = { 'scroll_documentation_up' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = {
          function(cmp)
            local sidekick = require('sidekick')
            if sidekick.nes_jump_or_apply() then
              return true
            end

            local copilot = require('copilot.suggestion')
            if copilot.is_visible() then
              copilot.accept()
              return true
            end

            if vim.lsp then
              for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                if client:supports_method('textDocument/inlineCompletion') then
                  local ic = vim.lsp.inline_completion
                  if ic and ic.get and ic.get() then
                    ic.select()
                    return true
                  end
                end
              end
            end

            local luasnip = require('luasnip')
            if luasnip.in_snippet() then
              return cmp.accept()
            end

            return cmp.select_and_accept()
          end,
          'snippet_forward',
          'fallback',
        },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono',
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          draw = {
            columns = {
              { 'label', 'label_description', gap = 1 },
              { 'kind_icon', 'kind' },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          treesitter_highlighting = true,
          window = {
            border = 'rounded',
          },
        },
        ghost_text = {
          enabled = true,
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
          code = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        providers = {
          lsp = {
            name = 'lsp',
            module = 'blink.cmp.sources.lsp',
            fallbacks = { 'buffer' },
          },
          path = {
            name = 'Path',
            module = 'blink.cmp.sources.path',
            score_offset = 3,
          },
          snippets = {
            name = 'snippets',
            module = 'blink.cmp.sources.snippets',
          },
          buffer = {
            name = 'Buffer',
            module = 'blink.cmp.sources.buffer',
          },
        },
      },
      cmdline = {
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == '/' or type == '?' then
            return { 'buffer' }
          elseif type == ':' or type == '@' then
            return { 'cmdline' }
          end
          return {}
        end,
        completion = {
          menu = {
            auto_show = true,
          },
        },
      },
      signature = {
        enabled = true,
        window = {
          border = 'rounded',
        },
      },
      snippets = {
        preset = 'luasnip',
      },
    },
    opts_extend = { 'sources.default', 'sources.providers' },
  },
}
