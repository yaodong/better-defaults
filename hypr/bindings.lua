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

-- Newer Omarchy binds SUPER + Q and SUPER + A too; unbind first so a press
-- doesn't fire both (a double close would also take the next focused window).
hl.unbind("SUPER + Q")
o.bind("SUPER + Q", "Quit (close window)", hl.dsp.window.close())
hl.unbind("SUPER + A")
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

-- Browser-aware SUPER keys: Chrome's Cmd shortcut in browsers, Omarchy's
-- original action everywhere else (same idea as SUPER + W).
local function browser_or(mods, key, fallback)
  return function()
    if active_window_is_browser() then
      send_shortcut(mods, key)
    else
      hl.dispatch(fallback)
    end
  end
end

hl.unbind("SUPER + T")
hl.unbind("SUPER + L")
hl.unbind("SUPER + K")
hl.unbind("SUPER + P")
o.bind("SUPER + T", "New tab (browser) or toggle floating", browser_or("CTRL", "T", hl.dsp.window.float({ action = "toggle" })))
o.bind("SUPER + L", "Address bar (browser) or toggle layout", browser_or("CTRL", "L", hl.dsp.exec_cmd("omarchy-hyprland-workspace-layout-toggle")))
o.bind("SUPER + K", "Cmd+K (browser) or keybindings", browser_or("CTRL", "K", hl.dsp.exec_cmd("omarchy-menu-keybindings")))
o.bind("SUPER + P", "Print (browser) or pseudo window", browser_or("CTRL", "P", hl.dsp.window.pseudo()))

o.bind("SUPER + D", "Bookmark page (browser)", browser_shortcut("CTRL", "D"))
o.bind("SUPER + Y", "History (browser)", browser_shortcut("CTRL", "H"))
o.bind("SUPER + SHIFT + bracketleft", "Previous tab (browser)", browser_shortcut("CTRL", "Prior"))
o.bind("SUPER + SHIFT + bracketright", "Next tab (browser)", browser_shortcut("CTRL", "Next"))
o.bind("SUPER + ALT + I", "Developer tools (browser)", browser_shortcut("CTRL SHIFT", "I"))
o.bind("SUPER + B", "Bold", gui_shortcut("CTRL", "B"))
o.bind("SUPER + I", "Italic", gui_shortcut("CTRL", "I"))
o.bind("SUPER + U", "Underline", gui_shortcut("CTRL", "U"))

-- Emacs/macOS text editing in browsers. Ctrl is free there because SUPER now
-- covers Chrome's shortcuts; other windows (terminals, editors) get the
-- original chord passed straight through.
local function browser_text_key(mod, key, action)
  o.bind(mod .. " + " .. key, nil, function()
    if active_window_is_browser() then
      action()
    else
      send_shortcut((mod:gsub(" %+ ", " ")), key)
    end
  end, { repeating = true })
end

local function sends(mods, key)
  return function() send_shortcut(mods, key) end
end

browser_text_key("CTRL", "A", sends("", "Home"))
browser_text_key("CTRL", "E", sends("", "End"))
browser_text_key("CTRL", "B", sends("", "Left"))
browser_text_key("CTRL", "F", sends("", "Right"))
browser_text_key("CTRL", "P", sends("", "Up"))
browser_text_key("CTRL", "N", sends("", "Down"))
browser_text_key("CTRL", "D", sends("", "Delete"))
browser_text_key("CTRL", "H", sends("", "BackSpace"))
browser_text_key("CTRL", "K", function()
  send_shortcut("SHIFT", "End")
  hl.timer(function() send_shortcut("", "Delete") end, { timeout = 80, type = "oneshot" })
end)

-- Option-style word movement (Alt+Left/Right is Back/Forward on Linux; use SUPER + [ / ] for that).
browser_text_key("ALT", "B", sends("CTRL", "Left"))
browser_text_key("ALT", "F", sends("CTRL", "Right"))
browser_text_key("ALT", "Left", sends("CTRL", "Left"))
browser_text_key("ALT", "Right", sends("CTRL", "Right"))
browser_text_key("ALT", "BackSpace", sends("CTRL", "BackSpace"))

-- More macOS Chrome shortcuts on keys Omarchy leaves free.
o.bind("SUPER + SHIFT + R", "Hard reload (browser)", browser_shortcut("CTRL SHIFT", "R"))
o.bind("SUPER + PERIOD", "Stop loading (browser)", browser_shortcut("", "Escape"))
o.bind("SUPER + SHIFT + J", "Downloads (browser)", browser_shortcut("CTRL", "J"))
o.bind("SUPER + ALT + B", "Bookmark manager (browser)", browser_shortcut("CTRL SHIFT", "O"))
o.bind("SUPER + ALT + J", "JavaScript console (browser)", browser_shortcut("CTRL SHIFT", "J"))
o.bind("SUPER + ALT + U", "View source (browser)", browser_shortcut("CTRL", "U"))
o.bind("SUPER + SHIFT + DELETE", "Clear browsing data (browser)", browser_shortcut("CTRL SHIFT", "Delete"))
o.bind("SUPER + SHIFT + V", "Paste as plain text", gui_shortcut("CTRL SHIFT", "V"))

-- Browser-aware overrides of Omarchy keys you rarely need while in Chrome.
hl.unbind("SUPER + SHIFT + N")
hl.unbind("SUPER + SHIFT + B")
hl.unbind("SUPER + SHIFT + A")
hl.unbind("SUPER + SHIFT + C")
hl.unbind("SUPER + ALT + LEFT")
hl.unbind("SUPER + ALT + RIGHT")
hl.unbind("SUPER + BACKSPACE")
o.bind("SUPER + SHIFT + N", "Incognito window (browser) or editor", browser_or("CTRL SHIFT", "N", hl.dsp.exec_cmd("omarchy-launch-editor")))
o.bind("SUPER + SHIFT + B", "Bookmarks bar (browser) or browser", browser_or("CTRL SHIFT", "B", hl.dsp.exec_cmd("omarchy-launch-browser")))
o.bind("SUPER + SHIFT + A", "Tab search (browser) or ChatGPT", browser_or("CTRL SHIFT", "A", hl.dsp.exec_cmd(o.launch_webapp("https://chatgpt.com"))))
o.bind("SUPER + SHIFT + C", "Inspect element (browser) or calendar", browser_or("CTRL SHIFT", "C", hl.dsp.exec_cmd(o.launch_webapp("https://app.hey.com/calendar/weeks/"))))
o.bind("SUPER + ALT + LEFT", "Previous tab (browser) or move into group left", browser_or("CTRL", "Prior", hl.dsp.window.move({ into_group = "l" })))
o.bind("SUPER + ALT + RIGHT", "Next tab (browser) or move into group right", browser_or("CTRL", "Next", hl.dsp.window.move({ into_group = "r" })))
o.bind("SUPER + BACKSPACE", "Delete to line start (browser) or toggle transparency", function()
  if active_window_is_browser() then
    send_shortcut("SHIFT", "Home")
    hl.timer(function() send_shortcut("", "BackSpace") end, { timeout = 80, type = "oneshot" })
  else
    hl.dispatch(hl.dsp.exec_cmd("omarchy-hyprland-window-transparency-toggle"))
  end
end)

-- Option-style selection, paragraph movement and forward word delete.
browser_text_key("ALT + SHIFT", "Left", sends("CTRL SHIFT", "Left"))
browser_text_key("ALT + SHIFT", "Right", sends("CTRL SHIFT", "Right"))
browser_text_key("ALT", "Up", sends("CTRL", "Up"))
browser_text_key("ALT", "Down", sends("CTRL", "Down"))
browser_text_key("ALT", "Delete", sends("CTRL", "Delete"))

-- macOS screenshot chords (⌘⌃⇧3/4/5). SUPER + SHIFT + 3/4 stay Omarchy's
-- move-to-workspace keys. code:12..14 are the 3/4/5 keys on any layout.
o.bind("SUPER + CTRL + SHIFT + code:12", "Screenshot of display", "omarchy-capture-screenshot fullscreen")
o.bind("SUPER + CTRL + SHIFT + code:13", "Screenshot of region", "omarchy-capture-screenshot region")
o.bind("SUPER + CTRL + SHIFT + code:14", "Capture menu", "omarchy-menu toggle capture")

-- SUPER + `: next window of the focused app, across workspaces (macOS Cmd+`).
o.bind("SUPER + code:49", "Next window of this app", function()
  local active = hl.get_active_window()
  if not active then
    return
  end

  local same, index = {}, 1
  for _, window in ipairs(hl.get_windows()) do
    if window.mapped and window.class == active.class then
      table.insert(same, window)
      if window.address == active.address then
        index = #same
      end
    end
  end

  if #same > 1 then
    local target = same[index % #same + 1]
    hl.dispatch(hl.dsp.focus({ window = "address:" .. target.address }))
  end
end)
