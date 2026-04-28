local user = os.getenv("USER") or ""
package.cpath = package.cpath .. ";/Users/" .. user .. "/.local/share/sketchybar_lua/?.so"

local sbar = require("sketchybar")
local colors = require("colors")

sbar.begin_config()

sbar.bar({
  position = "top",
  height = 34,
  blur_radius = 15,
  color = 0x00000000,
  sticky = "off",
  margin = 0,
  padding_left = 8,
  padding_right = 8,
  corner_radius = 12,
  y_offset = 8,
})

sbar.default({
  padding_left = 4,
  padding_right = 4,
  icon = {
    font = "CaskaydiaCove Nerd Font:Bold:14.0",
    color = colors.accent,
    padding_left = 8,
    padding_right = 4,
  },
  label = {
    font = "CaskaydiaCove Nerd Font:Bold:14.0",
    color = colors.text,
    padding_left = 4,
    padding_right = 8,
  },
  background = {
    color = colors.inactive,
    corner_radius = 8,
    height = 26,
    drawing = true,
  },
  popup = {
    background = {
      color = 0xe60c0c0c,
      corner_radius = 8,
      drawing = true,
      height = 0,
    },
    blur_radius = 20,
  },
})

sbar.add("event", "omniwm_workspace_change")

require("items")

sbar.end_config()
sbar.exec("launchctl load $HOME/Library/LaunchAgents/com.omniwm.sketchybar-watcher.plist 2>/dev/null")
sbar.update()
sbar.event_loop()
