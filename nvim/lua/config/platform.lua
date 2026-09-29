-- Platform detection shared by options and plugin specs.
local M = {}

M.macos = vim.fn.has("mac") == 1
M.linux = vim.fn.has("linux") == 1

-- Omarchy's theme picker points lua/plugins/theme.lua (created by ./link) at
-- this file; its presence means Omarchy owns the colorscheme.
M.omarchy_theme = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")
M.omarchy = vim.uv.fs_stat(M.omarchy_theme) ~= nil

return M
