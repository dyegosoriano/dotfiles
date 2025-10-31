-- https://github.com/folke/noice.nvim
-- if true then return {} end

return {
  {
    'folke/noice.nvim',
    -- enabled = false,
    opts = {
      presets = {
        long_message_to_split = false, -- long messages will be sent to a split
        command_palette = false,       -- position the cmdline and popupmenu together
        lsp_doc_border = false,        -- add a border to hover docs and signature help
        bottom_search = true,          -- use a classic bottom cmdline for search
        inc_rename = false,            -- enables an input dialog for inc-rename.nvim
      },
      popupmenu = {
        enabled = true,  -- enables the Noice popupmenu UI
        ---@type 'nui'|'cmp'
        backend = 'nui', -- backend to use to show regular cmdline completions
        ---@type NoicePopupmenuItemKind|false
        -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
        kind_icons = {}, -- set to `false` to disable icons
      },
      notify = {
        enabled = true,
        view = 'notify',
      },
    },
  },
}
