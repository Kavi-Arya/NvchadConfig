---@type ChadrcConfig
local M = {}

function M.check_environment()
  local dwm_running = io.popen("pgrep -x dwm"):read("*a")
  local hyprland_running = io.popen("pgrep -x Hyprland"):read("*a")
  local niri_running = io.popen("pgrep -x niri"):read("*a")

  if dwm_running ~= "" then
    M.base46 = { theme = "chadwal" }
    -- print("DWM")
  elseif hyprland_running ~= "" then
    M.base46 = { theme = "rosepine" }
    -- print("Hyprland")
  elseif niri_running ~= "" then
    M.base46 = { theme = "vscode_dark" }
    -- print("niri")
  else
    print("No supported environment detected.")
    M.base46 = { theme = "vscode_dark" }
  end
end

M.check_environment()
return M
