-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Mac-style SUPER shortcuts (SUPER acts like Cmd).
local browser_classes = {
  ["chromium"] = true,
  ["google-chrome"] = true,
  ["brave-browser"] = true,
  ["firefox"] = true,
  ["zen"] = true,
}

local function active_window_is_browser()
  local window = hl.get_active_window()
  return window ~= nil and browser_classes[window.class] == true
end

-- Same terminal check as Omarchy's universal clipboard (default/hypr/bindings/clipboard.lua).
local function active_window_is_terminal()
  local window = hl.get_active_window()
  if not window then
    return false
  end

  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end

  return false
end

-- Down/up split mirrors Omarchy's send_shortcut_once, avoiding stuck synthetic keys.
local function send_shortcut(mods, key)
  hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
  hl.timer(function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
  end, { timeout = 50, type = "oneshot" })
end

-- Send the shortcut to GUI apps only; in terminals these keys mean something
-- else (CTRL + Z suspends, CTRL + A jumps to line start), so do nothing there.
local function gui_shortcut(mods, key)
  return function()
    if not active_window_is_terminal() then
      send_shortcut(mods, key)
    end
  end
end

local function browser_shortcut(mods, key)
  return function()
    if active_window_is_browser() then
      send_shortcut(mods, key)
    end
  end
end

-- SUPER + W: close the tab in browsers, close the window elsewhere.
-- Web apps (chrome-*__-Default) don't match, so SUPER + W still closes them.
hl.unbind("SUPER + W")
o.bind("SUPER + W", "Close tab (browser) or window", function()
  if active_window_is_browser() then
    send_shortcut("CTRL", "W")
  else
    hl.dispatch(hl.dsp.window.close())
  end
end)

o.bind("SUPER + Q", "Quit (close window)", hl.dsp.window.close())
o.bind("SUPER + A", "Select all", gui_shortcut("CTRL", "A"))
o.bind("SUPER + Z", "Undo", gui_shortcut("CTRL", "Z"))
o.bind("SUPER + SHIFT + Z", "Redo", gui_shortcut("CTRL SHIFT", "Z"))
o.bind("SUPER + R", "Reload", gui_shortcut("CTRL", "R"))
o.bind("SUPER + N", "New window", gui_shortcut("CTRL", "N"))
o.bind("SUPER + SHIFT + T", "Reopen closed tab", browser_shortcut("CTRL SHIFT", "T"))
o.bind("SUPER + bracketleft", "Back (browser)", browser_shortcut("ALT", "Left"))
o.bind("SUPER + bracketright", "Forward (browser)", browser_shortcut("ALT", "Right"))

-- SUPER + CTRL + F: toggle full screen (was: tiled full screen).
hl.unbind("SUPER + CTRL + F")
o.bind("SUPER + CTRL + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- SUPER + SHIFT + RETURN: terminal (was: browser).
hl.unbind("SUPER + SHIFT + RETURN")
o.bind("SUPER + SHIFT + RETURN", "Terminal", { omarchy = "terminal" })

-- SUPER + RETURN: unbound (was: terminal) so apps like Chrome receive it.
hl.unbind("SUPER + RETURN")
o.bind("SUPER + RETURN", "Open in new tab (browser)", browser_shortcut("ALT", "RETURN"))

-- SUPER + F: find (was: full screen, now on SUPER + CTRL + F like macOS).
hl.unbind("SUPER + F")
o.bind("SUPER + F", "Find", gui_shortcut("CTRL", "F"))

-- Scratchpad moves off SUPER + S so it can be Save like macOS.
-- SUPER + ALT + S: toggle scratchpad (was: move window to scratchpad).
-- SUPER + SHIFT + ALT + S: move window to scratchpad.
hl.unbind("SUPER + S")
hl.unbind("SUPER + ALT + S")
o.bind("SUPER + ALT + S", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))
o.bind("SUPER + SHIFT + ALT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
o.bind("SUPER + S", "Save", gui_shortcut("CTRL", "S"))
