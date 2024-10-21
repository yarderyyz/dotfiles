local wezterm = require("wezterm")
local config = wezterm.config_builder()

local act = wezterm.action

config.color_scheme = "Catppuccin Mocha"
config.font_size = 16
config.command_palette_font_size = 16
config.command_palette_fg_color = "#cdd6f4"
config.command_palette_bg_color = "#1e1e2e"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 0,
}

-- Start From smart-splits.nvim
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "META" or "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
        }, pane)
      else
        if resize_or_move == "resize" then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end
-- End From smart-splits.nvim

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  -- move between split panes
  split_nav("move", "h"),
  split_nav("move", "j"),
  split_nav("move", "k"),
  split_nav("move", "l"),
  -- resize panes
  split_nav("resize", "h"),
  split_nav("resize", "j"),
  split_nav("resize", "k"),
  split_nav("resize", "l"),
  { key = "t", mods = "CTRL|CMD", action = act.SpawnTab("CurrentPaneDomain") },
  { key = '"', mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "'", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "l", mods = "LEADER", action = act.ShowDebugOverlay },
  { key = "c", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "/", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },
  {
    key = "z",
    mods = "LEADER",
    action = wezterm.action.TogglePaneZoomState,
  },
}

config.background = {
  {
    -- source = { File = "/Users/leegauthier/.config/wezterm/Revelstoke-British-Columbia.jpg" },
    source = { File = "/Users/leegauthier/.config/wezterm/taiwan.jpg" },
    horizontal_align = "Center",
  },
  {
    source = {
      Gradient = {
        orientation = { Linear = { angle = -45.0 } },
        colors = {
          "#181825",
          "#11111b",
          "#1e1e2e",
        },
        interpolation = "Linear",
        blend = "Rgb",
      },
    },
    height = "120%",
    width = "120%",
    vertical_offset = "-10%",
    horizontal_offset = "-10%",
    opacity = 0.92,
  },
}

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.7,
}

-- wezterm.on("gui-startup", function(cmd)
--   local tab, pane, window = mux.spawn_window(cmd or {})
--   -- Create a split occupying the right 1/3 of the screen
--   pane:split({ size = 1.3 })
--   -- Create another split in the right of the remaining 2/3
--   -- of the space; the resultant split is in the middle
--   -- 1/3 of the display and has the focus.
--   pane:split({ size = 0.5 })
-- end)

return config
