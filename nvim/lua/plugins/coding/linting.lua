return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require('lint')

      local function has_exec(cmd)
        return vim.fn.executable(cmd) == 1
      end

      local linters_by_ft = {}

      if has_exec('eslint') then
        linters_by_ft.javascript = { 'eslint' }
        linters_by_ft.typescript = { 'eslint' }
        linters_by_ft.javascriptreact = { 'eslint' }
        linters_by_ft.typescriptreact = { 'eslint' }
      end

      if has_exec('pylint') then
        linters_by_ft.python = { 'pylint' }
      end

      if has_exec('golangci-lint') then
        linters_by_ft.go = { 'golangci_lint' }
      end

      if has_exec('cargo') then
        linters_by_ft.rust = { 'clippy' }
      end

      if has_exec('shellcheck') then
        linters_by_ft.sh = { 'shellcheck' }
        linters_by_ft.bash = { 'shellcheck' }
        linters_by_ft.zsh = { 'shellcheck' }
      end

      if has_exec('hadolint') then
        linters_by_ft.dockerfile = { 'hadolint' }
      end

      if has_exec('jsonlint') then
        linters_by_ft.json = { 'jsonlint' }
      end

      if has_exec('yamllint') then
        linters_by_ft.yaml = { 'yamllint' }
      end

      if has_exec('markdownlint') then
        linters_by_ft.markdown = { 'markdownlint' }
      end

      if has_exec('stylelint') then
        linters_by_ft.css = { 'stylelint' }
        linters_by_ft.scss = { 'stylelint' }
        linters_by_ft.less = { 'stylelint' }
      end

      lint.linters_by_ft = linters_by_ft

      local lint_augroup = vim.api.nvim_create_augroup('nvim-lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.opt.buftype:get() == '' then
            lint.try_lint()
          end
        end,
      })

      vim.keymap.set('n', '<leader>cl', function()
        lint.try_lint()
      end, { desc = 'Lint: Trigger linting for current file' })
    end,
  },
}
