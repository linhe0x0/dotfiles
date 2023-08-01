local config = function()
  --
  -- The following configuration is inspired from https://github.com/neovim/nvim-lspconfig#suggested-configuration.
  --
  local keymap = vim.keymap

  local lspconfig = require("lspconfig")

  -- Add additional capabilities supported by nvim-cmp
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- Enable the language server for js/ts files:
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver
  lspconfig.tsserver.setup({
    capabilities = capabilities,
  })

  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap = true, silent = true }

  keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
  keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
  keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

  -- Use LspAttach autocommand to only map the following keys
  -- after the language server attaches to the current buffer
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

      -- Buffer local mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local opts = { buffer = ev.buf }
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format { async = true }
      end, opts)
    end,
  })
end

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPost", "BufWinEnter", "BufNewFile" },
  config = config,
}
