return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				config = function()
					local navbuddy = require("nvim-navbuddy")

					navbuddy.setup({})

					-- Mappings.
					local opts = { noremap = true, silent = true }

					vim.keymap.set("n", "<leader>nb", navbuddy.open, opts)
				end,
			},
		},
		config = function()
			local lspconfig = require("lspconfig")
			local schemas = require("schemastore").json.schemas()

			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				severity_sort = true,
			})

			-- Add additional capabilities supported by nvim-cmp
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(client, bufnr)
				local navic = require("nvim-navic")
				local navbuddy = require("nvim-navbuddy")

				if client.server_capabilities.documentSymbolProvider then
					navic.attach(client, bufnr)
					navbuddy.attach(client, bufnr)
				end

				-- Enable the inlay hints by default.
				if client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(true, {
						bufnr = buffer,
					})
				end
			end

			-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
			lspconfig.jsonls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					json = {
						schemas = schemas,
						format = { enable = true },
						validate = { enable = true },
					},
				},
			})

			lspconfig.bashls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			lspconfig.volar.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- Mappings.
			local opts = { noremap = true, silent = true }

			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(args)
					local buffer = args.buf

					-- Enable completion triggered by <c-x><c-o>
					vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = buffer }

					vim.keymap.set("n", "glD", function()
						vim.cmd("vsplit")
						vim.lsp.buf.declaration()
					end, opts)
					vim.keymap.set("n", "gld", function()
						vim.cmd("vsplit")
						vim.lsp.buf.definition()
					end, opts)
					vim.keymap.set("n", "glr", function()
						vim.cmd("vsplit")
						vim.lsp.buf.references()
					end, opts)
					vim.keymap.set("n", "gli", function()
						vim.cmd("vsplit")
						vim.lsp.buf.implementation()
					end, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		lazy = true,
		cmd = "Mason",
		keys = {
			{ "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
		},
		build = ":MasonUpdate",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = true,
		dependencies = {
			"williamboman/mason.nvim",
		},
		opts = {
			-- ALl available LSP servers can be found at the following url:
			-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
			ensure_installed = {
				"ts_ls",
				"volar",
				"jsonls",
				"bashls",
			},
			automatic_installation = true,
		},
	},
}
