if true then return {} end

return {
  {
    dir = vim.fn.stdpath("config") .. "/lua",
    name = "theme.nvim",
    priority = 1000,
    lazy = false,

    config = function()
      require("colors.theme").setup()
    end,
  },
}
