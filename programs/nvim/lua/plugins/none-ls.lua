-- https://github.com/nvimtools/none-ls.nvim
-- if true then return {} end

return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- Biome para formatação e diagnósticos
        null_ls.builtins.diagnostics.biome,
        null_ls.builtins.formatting.biome,

        -- Outros formatadores
        null_ls.builtins.formatting.shellharden,
        null_ls.builtins.diagnostics.erb_lint,
        null_ls.builtins.formatting.stylua,
      },

      -- Habilita formatação ao salvar
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,
}
