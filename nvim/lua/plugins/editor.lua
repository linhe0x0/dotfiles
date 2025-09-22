return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-refactor",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		keys = {
			{ "<c-space>", desc = "Increment selection" },
			{ "<bs>", desc = "Decrement selection", mode = "x" },
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
					use_languagetree = true,
					additional_vim_regex_highlighting = false,
					-- To disable slow treesitter highlight for large files.
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
				},
				indent = {
					enable = true,
				},
				ensure_installed = {
					"bash",
					"javascript",
					"typescript",
					"tsx",
					"vue",
					"json",
					"yaml",
					"go",
					"rust",
					"lua",
					"markdown",
					"markdown_inline",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]["] = "@function.outer",
							["]m"] = "@class.outer",
						},
						goto_next_end = {
							["]]"] = "@function.outer",
							["]M"] = "@class.outer",
						},
						goto_previous_start = {
							["[["] = "@function.outer",
							["[m"] = "@class.outer",
						},
						goto_previous_end = {
							["[]"] = "@function.outer",
							["[M"] = "@class.outer",
						},
					},
				},
				refactor = {
					highlight_definitions = {
						enable = true,
						clear_on_cursor_move = false,
					},
					highlight_current_scope = {
						enable = false,
					},
					smart_rename = {
						enable = true,
						keymaps = {
							smart_rename = "gsr",
						},
					},
					navigation = {
						enable = true,
						keymaps = {
							goto_definition = "gnd",
							list_definitions = "gnD",
							list_definitions_toc = "gO",
							goto_next_usage = "<a-*>",
							goto_previous_usage = "<a-#>",
						},
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		lazy = true,
		config = function()
			-- When in diff mode, we want to use the default
			-- vim text objects c & C instead of the treesitter ones.
			local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
			local configs = require("nvim-treesitter.configs")
			for name, fn in pairs(move) do
				if name:find("goto") == 1 then
					move[name] = function(q, ...)
						if vim.wo.diff then
							local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
							for key, query in pairs(config or {}) do
								if q == query and key:find("[%]%[][cC]") then
									vim.cmd("normal! " .. key)
									return
								end
							end
						end
						return fn(q, ...)
					end
				end
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		opts = {
			enable = true,
			mode = "cursor",
			max_lines = 3,
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-lua/popup.nvim",
		},
		keys = {
			{
				"<C-p>",
				"<cmd>Telescope find_files<cr>",
				desc = "Find Files (root dir)",
				mode = "n",
				silent = true,
				noremap = true,
			},
			{
				"<leader>ff",
				"<cmd>Telescope find_files<cr>",
				desc = "Find Files (root dir)",
				mode = "n",
				silent = true,
				noremap = true,
			},
			{
				"<leader>/",
				"<cmd>Telescope live_grep<cr>",
				desc = "Grep (root dir)",
				mode = "n",
				silent = true,
				noremap = true,
			},
			{
				"<leader>fg",
				"<cmd>Telescope live_grep<cr>",
				desc = "Grep (root dir)",
				mode = "n",
				silent = true,
				noremap = true,
			},
			{
				"<leader>fb",
				"<cmd>Telescope buffers<cr>",
				desc = "Buffers",
				mode = "n",
				silent = true,
				noremap = true,
			},
			{
				"<leader>fh",
				"<cmd>Telescope help_tags<cr>",
				desc = "Help Pages",
				mode = "n",
				silent = true,
				noremap = true,
			},
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local fb_actions = require("telescope").extensions.file_browser.actions

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-o>"] = actions.select_default, -- open the selection in the current buffer
							["<C-s>"] = actions.select_horizontal, -- go to file selection as a split
							["<C-x>"] = actions.select_horizontal, -- go to file selection as a split
							["<C-v>"] = actions.select_vertical, -- open the selection in a new vertical split
							["<C-t>"] = actions.select_tab, -- open the selection in a new tab
							["<C-k>"] = actions.move_selection_previous, -- move to prev result
							["<C-j>"] = actions.move_selection_next, -- move to next result
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
						},
						n = {
							["o"] = actions.select_default, -- open the selection in the current buffer
							["s"] = actions.select_horizontal, -- go to file selection as a split
							["x"] = actions.select_horizontal, -- go to file selection as a split
							["v"] = actions.select_vertical, -- open the selection in a new vertical split
							["t"] = actions.select_tab, -- open the selection in a new tab
							["k"] = actions.move_selection_previous, -- move to prev result
							["j"] = actions.move_selection_next, -- move to next result
							["q"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
						},
					},
				},
				extensions = {
					file_browser = {
						hijack_netrw = true, -- disables netrw and use telescope-file-browser in its place
						mappings = {
							["i"] = {
								["<C-o>"] = actions.select_default, -- open the selection in the current buffer
								["<C-s>"] = actions.select_horizontal, -- go to file selection as a split
								["<C-x>"] = actions.select_horizontal, -- go to file selection as a split
								["<C-v>"] = actions.select_vertical, -- open the selection in a new vertical split
								["<C-t>"] = actions.select_tab, -- open the selection in a new tab
								["<C-c>"] = fb_actions.create, -- Create file/folder at current path (trailing path separator creates folder)
								["<Tab>"] = fb_actions.change_cwd, -- change working directory of nvim to the selected file/folder
							},
							["n"] = {
								["o"] = actions.select_default, -- open the selection in the current buffer
								["s"] = actions.select_horizontal, -- go to file selection as a split
								["x"] = actions.select_horizontal, -- go to file selection as a split
								["v"] = actions.select_vertical, -- open the selection in a new vertical split
								["t"] = actions.select_tab, -- open the selection in a new tab
								["<Tab>"] = fb_actions.change_cwd, -- change working directory of nvim to the selected file/folder
								["c"] = fb_actions.create, -- create file/folder at current path (trailing path separator creates folder)
								["p"] = fb_actions.goto_parent_dir, -- go to parent directory
								["/"] = function() -- enter the insert mode to search files
									vim.cmd("startinsert")
								end,
								["<C-u>"] = function(prompt_bufnr) -- move the selection 10 lines up
									for i = 1, 10 do
										actions.move_selection_previous(prompt_bufnr)
									end
								end,
								["<C-d>"] = function(prompt_bufnr) -- move the selection 10 lines down
									for i = 1, 10 do
										actions.move_selection_next(prompt_bufnr)
									end
								end,
								["<PageUp>"] = actions.preview_scrolling_up, -- scroll up the preview pane
								["<PageDown>"] = actions.preview_scrolling_down, -- scroll down the preview pane
							},
						},
					},
				},
			})

			telescope.load_extension("file_browser")
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{
				"<leader>fe",
				"<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>",
				mode = "n",
				silent = true,
				noremap = true,
			},
		},
	},
	{
		"smjonas/inc-rename.nvim",
		event = "VeryLazy",
		cmd = "IncRename",
		config = true,
	},
	{
		"junegunn/vim-easy-align",
		event = "VeryLazy",
		cmd = "EasyAlign",
		keys = {
			{ "ga", "<Plug>(EasyAlign)", mode = "n", silent = true, noremap = false },
			{ "ga", "<Plug>(EasyAlign)", mode = "x", silent = true, noremap = false },
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			--   plugins = { spelling = true },
			--   defaults = {
			--     -- mode = { "n", "v" },
			--     -- ["g"] = { name = "+goto" },
			--     -- ["gs"] = { name = "+surround" },
			--     -- ["]"] = { name = "+next" },
			--     -- ["["] = { name = "+prev" },
			--     -- ["<leader><tab>"] = { name = "+tabs" },
			--     -- ["<leader>b"] = { name = "+buffer" },
			--     -- ["<leader>c"] = { name = "+code" },
			--     -- ["<leader>f"] = { name = "+file/find" },
			--     -- ["<leader>g"] = { name = "+git" },
			--     -- ["<leader>gh"] = { name = "+hunks" },
			--     -- ["<leader>q"] = { name = "+quit/session" },
			--     -- ["<leader>s"] = { name = "+search" },
			--     -- ["<leader>u"] = { name = "+ui" },
			--     -- ["<leader>w"] = { name = "+windows" },
			--     -- ["<leader>x"] = { name = "+diagnostics/quickfix" },
			--   },
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
		-- config = function(_, opts)
		--   local wk = require("which-key")
		--   wk.setup(opts)
		--   wk.register(opts.defaults)
		-- end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Flash Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"s1n7ax/nvim-window-picker",
		},
		cmd = "Neotree",
		keys = {
			{
				"<leader>e",
				function()
					require("neo-tree.command").execute({ toggle = true })
				end,
				desc = "Explorer NeoTree (root dir)",
			},
			{ "<C-b>", "<leader>e", desc = "Explorer NeoTree (root dir)", remap = true },
			{
				"<leader>ge",
				function()
					require("neo-tree.command").execute({ source = "git_status", toggle = true })
				end,
				desc = "Git explorer",
			},
			{
				"<leader>be",
				function()
					require("neo-tree.command").execute({ source = "buffers", toggle = true })
				end,
				desc = "Buffer explorer",
			},
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		opts = {
			close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			sort_case_insensitive = false,
			sources = { "filesystem", "buffers", "git_status", "document_symbols" },
			open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
			},
			window = {
				position = "right",
				mappings = {
					["e"] = "open",
					["E"] = "open_with_window_picker",
					["s"] = "open_split",
					["S"] = "open_vsplit",
					["v"] = "open_vsplit",
					["c"] = "close_node",
					["C"] = "close_all_subnodes",
					["z"] = "close_all_nodes",
					["q"] = "close_window",
					["R"] = "refresh",
					["m"] = "move",
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
			},
			nesting_rules = {
				["package.json"] = {
					pattern = "^package%.json$",
					files = { "package-lock.json", "yarn*" },
				},
				["docker"] = {
					pattern = "^dockerfile$",
					ignore_case = true,
					files = { ".dockerignore", "docker-compose.*", "dockerfile*" },
				},
			},
		},
	},
	{
		"s1n7ax/nvim-window-picker",
		name = "window-picker",
		event = "VeryLazy",
		config = function()
			require("window-picker").setup({
				filter_rules = {
					include_current_win = false,
					autoselect_one = true,
					-- filter using buffer options
					bo = {
						-- if the file type is one of following, the window will be ignored
						filetype = { "neo-tree", "neo-tree-popup", "notify" },
						-- if the buffer type is one of following, the window will be ignored
						buftype = { "terminal", "quickfix" },
					},
				},
			})
		end,
	},
	{
		"RRethy/vim-illuminate",
		event = "VeryLazy",
		opts = {
			delay = 200,
			large_file_cutoff = 2000,
			large_file_overrides = {
				providers = { "lsp" },
			},
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
		keys = {
			{ "]]", desc = "Next Reference" },
			{ "[[", desc = "Prev Reference" },
		},
	},
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true },
		keys = {
			{
				"<leader>xx",
				"<cmd>TroubleToggle<cr>",
				desc = "Diagnostics (Troble)",
				mode = "n",
				silent = true,
				noremap = true,
			},
			{
				"<leader>xw",
				"<cmd>TroubleToggle workspace_diagnostics<cr>",
				desc = "Workspace Diagnostics (Trouble)",
				mode = "n",
				silent = true,
				noremap = true,
			},
			{
				"<leader>xd",
				"<cmd>TroubleToggle document_diagnostics<cr>",
				desc = "Document Diagnostics (Trouble)",
				mode = "n",
				silent = true,
				noremap = true,
			},
			{
				"<leader>xl",
				"<cmd>TroubleToggle loclist<cr>",
				desc = "Location List (Trouble)",
				mode = "n",
				silent = true,
				noremap = true,
			},
			{
				"<leader>xq",
				"<cmd>TroubleToggle quickfix<cr>",
				desc = "Quickfix List (Trouble)",
				mode = "n",
				silent = true,
				noremap = true,
			},
			{
				"[e",
				function()
					if require("trouble").is_open() then
						require("trouble").previous({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Previous trouble/quickfix item",
			},
			{
				"]e",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Next trouble/quickfix item",
			},
		},
	},
	{
		"stevearc/conform.nvim",
		dependencies = {
			"mason-org/mason.nvim",
		},
		lazy = true,
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>p",
				function()
					require("conform").format({
						async = true,
						lsp_fallback = true,
					})
				end,
				-- mode = { "n", "v" },
				mode = "n",
				silent = true,
				noremap = true,
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				-- Conform will run multiple formatters sequentially
				go = { "goimports", "gofmt" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
			},
		},
	},
}
