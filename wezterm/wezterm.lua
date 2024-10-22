local wezterm = require("wezterm")
local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action

config.default_prog = { "/bin/zsh", "-l" }

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

local function simple_default(window, cwd)
  local nvim_pane = window:active_pane()
  nvim_pane:split({ direction = "Bottom", size = 0.33 })
  -- window:perform_action(wezterm.action.SplitVertical, nvim_pane)
  os.execute("sleep " .. tonumber(0.5))
  nvim_pane:send_text("nvim\n")
end

local workspaces = {
  -- Workspace definition for "aurora-ui"
  ["aurora-ui"] = {
    cwd = "/Users/leegauthier/Projects/limbicmedia/aurora-web-ui/",
    setup = function(window, cwd)
      local nvim_pane = window:active_pane()

      nvim_pane:split({ direction = "Bottom", size = 0.33 })

      window:perform_action(
        wezterm.action.SpawnCommandInNewTab({
          cwd = cwd,
        }),
        nvim_pane
      )
      local server_pane = window:active_pane()

      window:perform_action(wezterm.action.ActivateTab(0), nvim_pane)

      -- Sleep to give OS time to load the shell before sending the commands
      os.execute("sleep " .. tonumber(0.4))
      nvim_pane:send_text("nvim\n")
      server_pane:send_text("yarn start:maestro --open 0\n")
    end,
  },
  ["termban"] = {
    cwd = "/Users/leegauthier/Projects/games/termban",
    setup = simple_default,
  },
  -- You can add more workspaces here
  -- ["another-workspace"] = {
  --   cwd = "~/path/to/another/project/",
  --   setup = function(window, cwd)
  --     -- Setup code for the other workspace
  --   end,
  -- },
}

local function create_workspace_selector(window, pane)
  -- Build the list of workspaces to display
  local items = {}
  local keys = {}
  for name, _ in pairs(workspaces) do
    keys[name] = true
    table.insert(items, {
      label = name,
      id = name,
    })
  end

  for _, name in ipairs(wezterm.mux.get_workspace_names()) do
    if keys[name] == nil then
      table.insert(items, {
        label = name,
        id = name,
      })
    end
  end

  -- Show the selector
  window:perform_action(
    act.InputSelector({
      title = "Select a workspace",
      choices = items,
      action = wezterm.action_callback(function(window, pane, id, label)
        if not id then
          return
        end

        local workspace = workspaces[id]
        if not workspace then
          window:perform_action(
            wezterm.action.SwitchToWorkspace({
              name = id,
            }),
            pane
          )
        else
          -- Check if the workspace already exists
          local existing_workspaces = wezterm.mux.get_workspace_names()
          local workspace_exists = false
          for _, w in ipairs(existing_workspaces) do
            if w == id then
              workspace_exists = true
              break
            end
          end

          -- Open workspace if it exists
          window:perform_action(
            wezterm.action.SwitchToWorkspace({
              name = id,
              spawn = { cwd = workspace.cwd },
            }),
            pane
          )
          -- Perform the custom setup for the new workspace
          if not workspace_exists then
            workspace.setup(window, workspace.cwd)
          end
        end
      end),
    }),
    pane
  )
end

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
  {
    key = "w",
    mods = "LEADER",
    action = wezterm.action_callback(create_workspace_selector),
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

wezterm.on("update-right-status", function(window, pane)
  window:set_right_status(window:active_workspace())
end)

return config
