local sbar = require("sketchybar")
local colors = require("colors")

local plugin_dir = os.getenv("CONFIG_DIR") .. "/plugins"

local function has_battery()
  local handle = io.popen("pmset -g batt 2>/dev/null")
  if not handle then
    return false
  end

  local output = handle:read("*a") or ""
  handle:close()
  return output:match("%d+%%") ~= nil
end

sbar.add("item", "spacer", {
  position = "center",
  background = { drawing = false },
  width = 80,
})

local clock = sbar.add("item", "clock", {
  position = "right",
  update_freq = 10,
  icon = { string = "󰥔", color = colors.gold },
  script = plugin_dir .. "/clock.sh",
  click_script = "open /System/Library/PreferencePanes/DateAndTime.prefPane",
  background = { drawing = false },
})

local status_items = { "clock" }

if has_battery() then
  local battery = sbar.add("item", "battery", {
    position = "right",
    update_freq = 120,
    icon = { string = "󰁺", color = colors.accent },
    script = plugin_dir .. "/battery.sh",
    background = { drawing = false },
  })
  local update_battery = function()
    sbar.exec("NAME=battery " .. plugin_dir .. "/battery.sh")
  end
  battery:subscribe("system_woke", update_battery)
  battery:subscribe("power_source_change", update_battery)
  table.insert(status_items, "battery")
end

local cpu = sbar.add("graph", "cpu", 52, {
  position = "right",
  update_freq = 2,
  graph = { color = colors.cpu_blue, fill_color = 0x00000000, line_width = 1.0 },
  background = { drawing = false },
  icon = {
    string = "",
    color = colors.text_muted,
    padding_left = 8,
    padding_right = 4,
  },
  label = {
    string = "cpu ??%",
    color = colors.text,
    font = "CaskaydiaCove Nerd Font:Bold:9.0",
    align = "right",
    padding_right = 8,
    width = 0,
    y_offset = 4,
  },
  click_script = "open -a 'Activity Monitor'",
})

cpu:subscribe("routine", function()
  sbar.exec(
    "top -l 1 | awk -F'[:,%]' '/CPU usage/ {printf \"%d\", ($2 + $4)}'",
    function(total_load)
      local load = tonumber(total_load) or 0
      local normalized = load / 100.0
      if normalized > 1.0 then
        normalized = 1.0
      elseif normalized < 0.0 then
        normalized = 0.0
      end

      local color = colors.cpu_blue
      if load > 30 then
        if load < 60 then
          color = colors.cpu_yellow
        elseif load < 80 then
          color = colors.cpu_orange
        else
          color = colors.cpu_red
        end
      end

      cpu:push({ normalized })
      cpu:set({
        graph = { color = color },
        label = { string = "cpu " .. load .. "%" },
      })
    end
  )
end)

cpu:subscribe("mouse.clicked", function()
  sbar.exec("open -a 'Activity Monitor'")
end)
table.insert(status_items, "cpu")

local claude_usage = sbar.add("item", "claude_usage", {
  position = "right",
  update_freq = 60,
  icon = {
    string = ":claude:",
    color = colors.claude,
    font = "sketchybar-app-font:Regular:16.0",
  },
  label = { color = colors.text },
  click_script = "open https://claude.ai/usage",
  popup = { height = 10 },
  drawing = false,
  background = { drawing = false },
})
local update_claude_usage = function()
  sbar.exec("NAME=claude_usage " .. plugin_dir .. "/claude_usage.sh")
end
claude_usage:subscribe("routine", update_claude_usage)
claude_usage:subscribe("forced", update_claude_usage)
claude_usage:subscribe("mouse.entered", function()
  claude_usage:set({ popup = { drawing = true } })
  sbar.exec(plugin_dir .. "/claude_detail.sh")
end)
claude_usage:subscribe("mouse.exited", function()
  claude_usage:set({ popup = { drawing = false } })
end)

sbar.add("item", "claude_usage.detail", {
  position = "popup.claude_usage",
  label = {
    string = "Session: 0%",
    color = colors.text,
    font = "CaskaydiaCove Nerd Font:Regular:11.0",
  },
  padding_left = 8,
  padding_right = 8,
  icon = { drawing = false },
  width = "dynamic",
  script = plugin_dir .. "/claude_detail.sh",
  updates = true,
})

local codex_usage = sbar.add("item", "codex_usage", {
  position = "right",
  update_freq = 60,
  icon = {
    string = ":codex:",
    color = colors.text,
    font = "sketchybar-app-font:Regular:16.0",
  },
  label = { color = colors.text },
  click_script = "open https://chatgpt.com/codex/cloud/settings/analytics#usage",
  popup = { height = 10 },
  drawing = false,
  background = { drawing = false },
})
local update_codex_usage = function()
  sbar.exec("NAME=codex_usage " .. plugin_dir .. "/codex_usage.sh")
end
codex_usage:subscribe("routine", update_codex_usage)
codex_usage:subscribe("forced", update_codex_usage)
codex_usage:subscribe("mouse.entered", function()
  codex_usage:set({ popup = { drawing = true } })
  sbar.exec(plugin_dir .. "/codex_detail.sh")
end)
codex_usage:subscribe("mouse.exited", function()
  codex_usage:set({ popup = { drawing = false } })
end)

sbar.add("item", "codex_usage.detail", {
  position = "popup.codex_usage",
  label = {
    string = "Used: 0%",
    color = colors.text,
    font = "CaskaydiaCove Nerd Font:Regular:11.0",
  },
  padding_left = 8,
  padding_right = 8,
  icon = { drawing = false },
  width = "dynamic",
  script = plugin_dir .. "/codex_detail.sh",
  updates = true,
})

sbar.add("item", "codex_usage.weekly", {
  position = "popup.codex_usage",
  label = {
    string = "Weekly: 0%",
    color = colors.text,
    font = "CaskaydiaCove Nerd Font:Regular:11.0",
  },
  padding_left = 8,
  padding_right = 8,
  icon = { drawing = false },
  width = "dynamic",
})

sbar.add("item", "codex_usage.reset", {
  position = "popup.codex_usage",
  label = {
    string = "Reset: -",
    color = colors.text,
    font = "CaskaydiaCove Nerd Font:Regular:11.0",
  },
  padding_left = 8,
  padding_right = 8,
  icon = { drawing = false },
  width = "dynamic",
})

sbar.add("item", "claude_usage.weekly", {
  position = "popup.claude_usage",
  label = {
    string = "Weekly: 0%",
    color = colors.text,
    font = "CaskaydiaCove Nerd Font:Regular:11.0",
  },
  padding_left = 8,
  padding_right = 8,
  icon = { drawing = false },
  width = "dynamic",
})

sbar.add("bracket", status_items, {
  background = {
    color = colors.inactive,
    corner_radius = 8,
    height = 26,
    padding_left = 8,
    padding_right = 8,
  },
})

sbar.add("item", "pill_gap", {
  position = "right",
  width = 10,
  background = { drawing = false },
  icon = { drawing = false },
  label = { drawing = false },
})

sbar.exec("sketchybar --move pill_gap before claude_usage")

sbar.add("bracket", { "claude_usage", "codex_usage" }, {
  background = {
    color = colors.inactive,
    corner_radius = 8,
    height = 26,
    padding_left = 4,
    padding_right = 4,
  },
})
