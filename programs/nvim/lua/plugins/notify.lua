-- https://github.com/rcarriga/nvim-notify
-- if true then return {} end

return {
  {
    'rcarriga/nvim-notify',
    opts = {
      render = 'default',
      top_down = false,
      timeout = 10000,
      stages = 'fade',
      level = 3,
      fps = 60,

      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    config = function()
      require('telescope').load_extension('notify')
    end,
  },
}
