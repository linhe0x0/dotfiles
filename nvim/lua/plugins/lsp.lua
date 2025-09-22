return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
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
			local navic = require("nvim-navic")
			local navbuddy = require("nvim-navbuddy")
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
				-- Set up navbar.
				if client.server_capabilities.documentSymbolProvider then
					navic.attach(client, bufnr)
					navbuddy.attach(client, bufnr)
				end

				-- Enable the inlay hints by default.
				if client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(true, {
						bufnr = bufnr,
					})
				end

				-- Set up folding.
				if client.supports_method("textDocument/foldingRange") then
					local win = vim.api.nvim_get_current_win()

					vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
				end
			end

			-- Harper is a grammar checker designed to run anywhere there is text.
			-- https://writewithharper.com/docs/integrations/neovim#Optional-Configuration
			vim.lsp.config("harper_ls", {
				settings = {
					["harper-ls"] = {
						linters = {
							SentenceCapitalization = false,
							SpellCheck = false,
						},
					},
				},
			})

			-- Official language server for Go.
			-- https://go.dev/gopls/
			vim.lsp.config("gopls", {
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#jsonls
			vim.lsp.config("jsonls", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					json = {
						schemas = schemas,
						format = {
							enable = true,
						},
						validate = {
							enable = true,
						},
					},
				},
			})

			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#bashls
			vim.lsp.config("bashls", {
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#vue_ls
			vim.lsp.config("vue_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#vtsls
			vim.lsp.config("vtsls", {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					if client.server_capabilities.documentSymbolProvider then
						navic.attach(client, bufnr)
						navbuddy.attach(client, bufnr)
					end

					-- Enable the inlay hints by default.
					if client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(true, {
							bufnr = bufnr,
						})
					end

					-- https://github.com/yioneko/vtsls#move-to-file-refactor
					client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
						---@type string, string, lsp.Range
						local action, uri, range = unpack(command.arguments)

						local function move(newf)
							client.request("workspace/executeCommand", {
								command = command.command,
								arguments = { action, uri, range, newf },
							})
						end

						local fname = vim.uri_to_fname(uri)
						client.request("workspace/executeCommand", {
							command = "typescript.tsserverRequest",
							arguments = {
								"getMoveToRefactoringFileSuggestions",
								{
									file = fname,
									startLine = range.start.line + 1,
									startOffset = range.start.character + 1,
									endLine = range["end"].line + 1,
									endOffset = range["end"].character + 1,
								},
							},
						}, function(_, result)
							---@type string[]
							local files = result.body.files
							table.insert(files, 1, "Enter new path...")
							vim.ui.select(files, {
								prompt = "Select move destination:",
								format_item = function(f)
									return vim.fn.fnamemodify(f, ":~:.")
								end,
							}, function(f)
								if f and f:find("^Enter new path") then
									vim.ui.input({
										prompt = "Enter move destination:",
										default = vim.fn.fnamemodify(fname, ":h") .. "/",
										completion = "file",
									}, function(newf)
										return newf and move(newf)
									end)
								elseif f then
									move(f)
								end
							end)
						end)
					end
				end,
				settings = {
					-- See the full configuration schema here:
					-- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
					complete_function_calls = true,
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
						experimental = {
							maxInlayHintLength = 30,
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "prompt" },
						suggest = {
							completeFunctionCalls = true,
						},
						inlayHints = {
							enumMemberValues = { enabled = true },
							functionLikeReturnTypes = { enabled = false },
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							variableTypes = { enabled = false },
						},
					},
				},
			})

			vim.lsp.enable("jsonls")
			vim.lsp.enable("bashls")
			vim.lsp.enable("vue_ls")
			vim.lsp.enable("vtsls")

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

					vim.keymap.set("n", "glD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gvlD", function()
						vim.api.nvim_cmd({ cmd = "vsplit", args = {} }, {})
						vim.lsp.buf.declaration()
					end, opts)

					vim.keymap.set("n", "gld", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gvld", function()
						vim.api.nvim_cmd({ cmd = "vsplit", args = {} }, {})
						vim.lsp.buf.definition()
					end, opts)

					vim.keymap.set("n", "glr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gvlr", function()
						vim.api.nvim_cmd({ cmd = "vsplit", args = {} }, {})
						vim.lsp.buf.references()
					end, opts)

					vim.keymap.set("n", "gli", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gvli", function()
						vim.api.nvim_cmd({ cmd = "vsplit", args = {} }, {})
						vim.lsp.buf.implementation()
					end, opts)

					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>td", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({
							async = true,
						})
					end, opts)
					vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>ca", function()
						vim.lsp.buf.code_action({
							context = {
								only = { "quickfix", "source", "refactor" },
								diagnostics = {},
							},
						})
					end, opts)
				end,
			})
		end,
	},
	{
		"mason-org/mason.nvim",
		lazy = true,
		cmd = "Mason",
		keys = {
			{ "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
		},
		build = ":MasonUpdate",
		config = true,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		lazy = true,
		dependencies = {
			"mason-org/mason.nvim",
		},
		opts = {
			-- Run `Mason` command to get All available LSP servers.
			ensure_installed = {
				"harper_ls", -- The slim, clean language checker for developers.
				"gopls", -- Google's lsp server for golang.
				"vtsls", -- LSP wrapper around the TypeScript extension bundled with VSCode.
				"vue_ls",
				"jsonls",
				"bashls",
			},
			automatic_installation = true,
		},
	},
}
