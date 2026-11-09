-- Custom actions used by the bindings in keys.lua.

local M = {}

local state = { last_window_id = nil }
M.state = state

local hostname = nil
local h = rex.exec({ "hostname" })
if h ~= nil and h.stdout ~= nil then
  hostname = h.stdout:gsub("%s+", ""):lower()
end

-- Convert a terminal pwd URI ("file://host/path") into a local filesystem
-- path. Returns nil for paths on other hosts or unparseable URIs.
local function local_path(uri)
  if type(uri) ~= "string" then
    return nil
  end
  local host, path = uri:match("^file://([^/]+)(.*)$")
  if host == nil or path == nil or path == "" then
    return nil
  end
  host = host:lower():gsub("%.local$", "")
  if hostname ~= nil and host ~= hostname then
    return nil
  end
  return (path:gsub("%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end))
end

local function focused_path()
  local t, err = rex.block.call("com.superlogical.terminal", "pwd", {})
  if err ~= nil or t == nil then
    return nil
  end
  return local_path(t.pwd)
end

local function remember_active_window()
  local view, err = rex.session.view{}
  if err == nil and view ~= nil then
    state.last_window_id = view.active_window_id
  end
end

local function window_exists(view, window_id)
  for _, w in ipairs(view.windows or {}) do
    if w.window_id == window_id then
      return true
    end
  end
  return false
end

-- Switch to the window focused before the current one.
function M.last_window()
  local view, err = rex.session.view{}
  if err ~= nil or view == nil then
    return true
  end
  local active = view.active_window_id
  local target = state.last_window_id
  if target ~= nil and target ~= active and window_exists(view, target) then
    local _, ferr = rex.session.focus_window{ window_id = target }
    if ferr == nil then
      state.last_window_id = active
      return true
    end
  end
  state.last_window_id = active
  return true
end

for _, d in ipairs({
  { "tab_previous", "Previous Tab", "client.tab.previous" },
  { "tab_next", "Next Tab", "client.tab.next" },
}) do
  rex.action{
    name = d[1],
    title = d[2],
    category = "Tmux",
    repeats = true,
    run = function()
      remember_active_window()
      rex.client.queue(d[3])
    end,
  }
end

local function tiled_blocks(view, window_id)
  for _, w in ipairs(view.windows or {}) do
    if w.window_id == window_id and w.layers ~= nil then
      local layer = w.layers[1]
      if layer ~= nil and layer.kind == "tiled" and layer.blocks ~= nil then
        return layer.blocks
      end
    end
  end
  return nil
end

local function focused_block_id(view, ctx)
  if ctx.block_id ~= nil then
    return ctx.block_id
  end
  for _, w in ipairs(view.windows or {}) do
    if w.window_id == view.active_window_id then
      return w.focused_block_id
    end
  end
  return nil
end

local function swap_pane(ctx, offset)
  local view, err = rex.session.view{}
  if err ~= nil or view == nil then
    return
  end
  local blocks = tiled_blocks(view, view.active_window_id)
  if blocks == nil or #blocks < 2 then
    return
  end
  local focused = focused_block_id(view, ctx)
  if focused == nil then
    return
  end
  local index
  for i, b in ipairs(blocks) do
    if b.block_id == focused then
      index = i
      break
    end
  end
  if index == nil then
    return
  end
  local count = #blocks
  local target = ((index - 1 + offset) % count) + 1
  local _, serr = rex.session.swap_blocks{
    block_id = focused,
    other_block_id = blocks[target].block_id,
  }
  if serr ~= nil then
    error(serr, 0)
  end
end

for _, d in ipairs({
  { "swap_pane_next", "Swap Pane with Next", 1 },
  { "swap_pane_previous", "Swap Pane with Previous", -1 },
}) do
  rex.action{
    name = d[1],
    title = d[2],
    category = "Tmux",
    run = function(ctx)
      swap_pane(ctx, d[3])
    end,
  }
end

-- repeats keeps the action firing while the key is held.
for _, d in ipairs({
  { "up", "Up" },
  { "down", "Down" },
  { "left", "Left" },
  { "right", "Right" },
}) do
  rex.action{
    name = "pane_focus_" .. d[1],
    title = "Focus Pane " .. d[2],
    category = "Tmux",
    repeats = true,
    run = function()
      rex.client.queue("pane.focus." .. d[1])
    end,
  }
  rex.action{
    name = "pane_resize_" .. d[1],
    title = "Resize Pane " .. d[2],
    category = "Tmux",
    repeats = true,
    run = function()
      rex.client.queue("pane.resize", { direction = d[1] })
    end,
  }
end

local function open_popup(options)
  local _, err = rex.session.new_layer{
    bounds = { 0.1, 0.15, 0.8, 0.7 },
    focus = true,
    layout = rex.layout.block{
      flavor = "com.superlogical.terminal.shell",
      options = options,
    },
  }
  if err ~= nil then
    error(err, 0)
  end
end

rex.action{
  name = "lazygit_popup",
  title = "Lazygit Popup",
  category = "Tmux",
  run = function()
    open_popup({ command = { "lazygit" }, cwd = focused_path() })
  end,
}

-- The selection is typed into the calling pane.
rex.action{
  name = "find_files_popup",
  title = "Find Files Popup",
  category = "Tmux",
  run = function(ctx)
    if ctx.session_id == nil or ctx.block_id == nil then
      error("requires a focused terminal", 0)
    end
    local command = "fzf | grep . | xargs -I{} rex send -s "
      .. ctx.session_id .. " -b " .. ctx.block_id .. " '{}'"
    open_popup({ command = { "sh", "-c", command }, cwd = focused_path() })
  end,
}

return M
