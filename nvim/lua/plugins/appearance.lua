local platform = require("config.platform")

local function is_dark()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:match("Dark") ~= nil
  end
  return false
end

local specs = {

  {
    "folke/noice.nvim",
    opts = {
      cmdline = { format = { cmdline = { lang = "" } } },
    },
  },

  -- incline: creating lightweight floating statuslines
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
      require("incline").setup({
        hide = {
          cursorline = true,
        },
      })
    end,
  },
}

-- Theme customization is macOS-only. On Omarchy the colorscheme comes from
-- lua/plugins/theme.lua (Omarchy's theme picker); see all-themes.lua and
-- omarchy-theme-hotreload.lua.
if not platform.macos then
  return specs
end

if not is_dark() then
  vim.o.background = "light"
end

vim.list_extend(specs, {

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },

  -- rose-pine: auto-switches between moon (dark) and dawn (light) based on
  -- vim.o.background. Re-apply on background change so running instances
  -- receive the swap when `theme-sync` flips the option.
  {
    "rose-pine/neovim",
    lazy = false,
    name = "rose-pine",
    priority = 1000,
    opts = {
      variant = "auto",
      dark_variant = "moon",
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd.colorscheme("rose-pine")
      vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        callback = function()
          vim.cmd.colorscheme("rose-pine")
        end,
      })
    end,
  },

  -- Disable unused default theme
  { "folke/tokyonight.nvim", enabled = false },
})

return specs
