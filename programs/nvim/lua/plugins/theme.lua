-- if true then return {} end

-- return {
--   {
--     dir = vim.fn.stdpath("config") .. "/lua",
--     name = "theme.nvim",
--     priority = 1000,
--     lazy = false,

--     config = function()
--       require("colors").setup()
--     end,
--   },
-- }

-- https://github.com/catppuccin/nvim
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,

    config = function()
      require("catppuccin").setup({
        -- transparent_background = true,
      })
      vim.cmd.colorscheme "catppuccin-mocha"
    end
  }
}

-- -- https://github.com/daltonmenezes/aura-theme/tree/main/packages/neovim
-- return {
--   { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
--   {
--     "baliestri/aura-theme",
--     priority = 1000,
--     lazy = false,
--     config = function(plugin)
--       vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
--       vim.cmd([[colorscheme aura-dark]])
--     end
--   }
-- }
