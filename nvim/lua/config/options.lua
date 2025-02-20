local opt = vim.opt

-- Settings
opt.encoding = "utf-8" -- The encoding displayed
opt.termguicolors = true -- Enable truecolor rendering
opt.background = "dark" -- Tell vim what the background color looks like
opt.number = true -- Always show line number.
opt.relativenumber = true -- Show the line number relative to the line with the cursor.
opt.tabstop = 2 -- Display 2 spaces for a tab.
opt.softtabstop = 2 -- How many columns the cursor moves right when you press <Tab>.
opt.shiftwidth = 2 -- Change the number of space characters inserted for indentation
opt.expandtab = true -- Converts tabs to spaces
opt.scrolloff = 999 -- Always show at least n lines above/below the cursor. set to a large value causes the cursor to stay in the middle line when possible.
opt.cursorline = true -- Enable highlighting of the current line
opt.cursorcolumn = true -- Enable highlighting of the current column
opt.cc = "80,120" -- Setup a ruler at specific columns.
opt.showmatch = true -- Enable a special bracket highlighting while in insert mode.
opt.ignorecase = true -- Makes pattern matching case-insensitive.
opt.smartcase = true -- Works as case-insensitive if you only use lowercase letters; otherwise, it will search in case-sensitive mode.
opt.splitbelow = true -- Horizontal splits will automatically be below
opt.splitright = true -- Vertical splits will automatically be to the right.
opt.foldenable = false -- Disable folding by default.
opt.list = true -- Show hidden characters such as tab, trailing space.
opt.mouse = "" -- Disable mouse support.
opt.history = 1000 -- Set the command-lines that you enter are remembered in a history table.
opt.listchars = "tab:» ,trail:~,extends:→,precedes:←,nbsp:+" -- Makes :set list (visible whitespace) prettier.

opt.exrc = true
opt.secure = true
