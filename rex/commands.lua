-- Commands the command palette types into the focused terminal,
-- ported from the Ghostty command palette entries.

local terminal = "com.superlogical.terminal"

local function type_line(command)
  local _, err = rex.block.call(terminal, "write", { data = command .. "\r" })
  if err ~= nil then
    error(err, 0)
  end
end

for _, c in ipairs({
  { "brew_update_all", "Brew Update All",
    "brew update && brew upgrade --formula -y && brew autoremove && brew cleanup --prune=all" },
  { "brew_cleanup", "Brew Cleanup",
    "brew autoremove && brew cleanup --prune=all" },
  { "brew_outdated", "Brew Outdated",
    "brew outdated" },
  { "npm_update_global", "NPM Update Global",
    "npm update -g --ignore-scripts" },
  { "npm_outdated_global", "NPM Outdated Global",
    "npm outdated -g" },
  { "dev_update_all", "Dev Update All",
    "brew update && brew upgrade --formula -y && brew autoremove && brew cleanup --prune=all; "
      .. "print '==> Updating global npm packages...' && npm update -g --ignore-scripts; omz update" },
}) do
  rex.action{
    name = c[1],
    title = c[2],
    category = "Dev",
    run = function()
      type_line(c[3])
    end,
  }
end
