return {
  {
    'stevearc/conform.nvim',
    dependencies = {
      'mason-org/mason.nvim',
    },
    lazy = true,
    cmd = 'ConformInfo',
    keys = {
      {
        '<leader>p',
        function()
          require('conform').format({
            async = true,
            lsp_fallback = true,
          })
        end,
        mode = 'n',
        silent = true,
        noremap = true,
        desc = 'Format buffer',
      },
    },
    opts = {
      formatters_by_ft = {
        go = { 'goimports', 'gofmt' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        markdown = { 'prettier' },
      },
    },
  },
}
