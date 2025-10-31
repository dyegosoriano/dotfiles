-- https://github.com/folke/which-key.nvim_set_hl
-- if true then return {} end

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'classic', -- tipo de layout (classic, modern, helix)
    win = {
      title_pos = 'center',
      title = true,
    },
    layout = {
      height = { min = 4, max = 10 },
      width = { min = 20, max = 50 },
      spacing = 3,
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({ buffer = 0 })
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
}
