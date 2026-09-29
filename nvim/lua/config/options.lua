-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if require("config.platform").linux then
  -- OSC 52 copy over tmux/SSH, Wayland paste (from Omarchy)
  require("config.remote_clipboard").setup()
end

vim.opt.relativenumber = false
vim.g.autoformat = false
vim.opt.undofile = true

vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",
  trail = "·",
  extends = "»",
  precedes = "«",
  nbsp = "␣",
}
