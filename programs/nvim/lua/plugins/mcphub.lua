-- https://github.com/ravitemer/mcphub.nvim
-- https://ravitemer.github.io/mcphub.nvim/
-- if true then return {} end

return {
  'ravitemer/mcphub.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', },
  build = 'npm install -g mcp-hub@latest',
  config = function()
    require('mcphub').setup({
      extensions = {
        avante = {
          make_slash_commands = true,
        },
      },
    })
  end,
}
