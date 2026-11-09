-- Key bindings. The "ctrl+a>" sequences act as a prefix; escape cancels
-- a half-typed sequence.

local actions = require("actions")

-- == Prefix ====================================================================

-- Double-press sends ctrl+a to the terminal.
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- == Window Management =========================================================

rex.bind("ctrl+a>c", "client.tab.new")
rex.bind("ctrl+a>n", "client.tab.new")

rex.bind("ctrl+a>ctrl+h", "tab_previous")
rex.bind("ctrl+a>ctrl+l", "tab_next")

rex.bind("ctrl+a>tab", actions.last_window)

-- == Pane Management ===========================================================

rex.bind("ctrl+a>v", "pane.split.right")
rex.bind("ctrl+a>shift+\\", "pane.split.right")
rex.bind("ctrl+a>b", "pane.split.down")
rex.bind("ctrl+a>-", "pane.split.down")

rex.bind("ctrl+a>k", "pane_focus_up")
rex.bind("ctrl+a>j", "pane_focus_down")
rex.bind("ctrl+a>h", "pane_focus_left")
rex.bind("ctrl+a>l", "pane_focus_right")

rex.bind("ctrl+a>shift+.", "swap_pane_next")
rex.bind("ctrl+a>shift+,", "swap_pane_previous")

rex.bind("ctrl+a>shift+k", "pane_resize_up")
rex.bind("ctrl+a>shift+j", "pane_resize_down")
rex.bind("ctrl+a>shift+h", "pane_resize_left")
rex.bind("ctrl+a>shift+l", "pane_resize_right")

rex.bind("ctrl+a>m", "session.switch")
rex.bind("ctrl+a>z", "pane.zoom")

rex.bind("ctrl+a>x", "pane.close")
rex.bind("ctrl+a>shift+x", "client.tab.close")

-- == Sessions ==================================================================

rex.bind("ctrl+a>ctrl+n", "session.new")
rex.bind("ctrl+a>ctrl+s", "session.switch")

-- == Utilities =================================================================

rex.bind("ctrl+a>r", "client.config.reload")
rex.bind("ctrl+a>ctrl+k", "com.superlogical.terminal.clear")

rex.bind("ctrl+a>p", "pane.new_floating")
rex.bind("ctrl+a>g", "lazygit_popup")
rex.bind("ctrl+a>f", "find_files_popup")
