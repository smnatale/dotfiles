local sbar = require("sketchybar")
local colors = require("colors")

local menu_watcher = sbar.add("item", "menu.watcher", {
  drawing = false,
  updates = true,
})

local swap_controller = sbar.add("item", "menu.swap_controller", {
  drawing = false,
  updates = true,
})

local max_items = 12
local menu_items = {}
for i = 1, max_items, 1 do
  local click_script = "osascript -e "
    .. "\"tell application \\\"System Events\\\" "
    .. "to tell (first process whose frontmost is true) "
    .. "to click menu bar item "
    .. i
    .. " of menu bar 1\""
  menu_items[i] = sbar.add("item", "menu." .. i, {
    position = "left",
    drawing = false,
    icon = { drawing = false },
    label = {
      color = colors.text,
      padding_left = 6,
      padding_right = 6,
      font = "CaskaydiaCove Nerd Font:Semibold:13.0",
    },
    click_script = click_script,
  })
end

sbar.add("bracket", { "/menu\\..*/" }, {
  background = { color = colors.inactive },
})

local menu_list_script = table.concat({
  "osascript",
  "-e 'tell application \"System Events\"'",
  "-e 'tell (first process whose frontmost is true)'",
  "-e 'set menuNames to name of every menu bar item of menu bar 1'",
  "-e 'return menuNames'",
  "-e 'end tell'",
  "-e 'end tell'",
}, " ")

local function update_menus()
  sbar.exec(menu_list_script, function(output)
    sbar.set("/menu\\..*/", { drawing = false })
    local idx = 1
    local normalized = (output or ""):gsub(",%s*", "\n")
    for menu in string.gmatch(normalized, "[^\r\n]+") do
      if idx <= max_items then
        menu_items[idx]:set({ drawing = true, label = menu })
      end
      idx = idx + 1
    end
  end)
end

menu_watcher:subscribe("front_app_switched", update_menus)

swap_controller:subscribe("swap_menus_and_spaces", function()
  local showing_menus = menu_items[1]:query().geometry.drawing == "on"
  if showing_menus then
    menu_watcher:set({ updates = false })
    sbar.set("/menu\\..*/", { drawing = false })
    sbar.set("/space\\..*/", { drawing = true })
    sbar.set("spaces.indicator", { drawing = true })
  else
    menu_watcher:set({ updates = true })
    sbar.set("/space\\..*/", { drawing = false })
    sbar.set("spaces.indicator", { drawing = false })
    update_menus()
  end
end)

update_menus()
