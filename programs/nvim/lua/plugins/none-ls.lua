-- none-ls configuration with Biome
-- https://github.com/nvimtools/none-ls.nvim

return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local null_ls = require("null-ls")

    local biome_filetypes = {
      "typescriptreact",
      "javascriptreact",
      "typescript",
      "javascript",
      "jsonc",
      "json",
    }

    -- Configuração customizada do Biome para formatação
    local biome_formatting = {
      method = null_ls.methods.FORMATTING,
      filetypes = biome_filetypes,
      generator = null_ls.formatter({
        command = "biome",
        args = { "format", "--write", "--stdin-file-path", "$FILENAME" },
        to_stdin = true,
        from_stderr = false,
        check_exit_code = function(code)
          return code <= 1
        end,
        condition = function(utils)
          return utils.root_has_file({ "biome.json", "biome.jsonc" })
        end,
      }),
    }

    -- Configuração para Biome diagnostics (linting)
    local biome_diagnostics = {
      method = null_ls.methods.DIAGNOSTICS,
      filetypes = biome_filetypes,
      generator = null_ls.generator({
        command = "biome",
        args = { "check", "--stdin-file-path", "$FILENAME", "--reporter=json" },
        to_stdin = true,
        format = "json",
        check_exit_code = function(code)
          return code <= 1
        end,
        condition = function(utils)
          return utils.root_has_file({ "biome.json", "biome.jsonc" })
        end,
        on_output = function(params)
          local diagnostics = {}
          if params.output and params.output ~= "" then
            local ok, result = pcall(vim.fn.json_decode, params.output)
            if ok and result and result.diagnostics then
              for _, diagnostic in ipairs(result.diagnostics) do
                if diagnostic.location and diagnostic.location.span then
                  table.insert(diagnostics, {
                    row = diagnostic.location.span.start.line + 1,
                    col = diagnostic.location.span.start.column,
                    message = diagnostic.description or diagnostic.message or "Biome diagnostic",
                    severity = diagnostic.severity == "error" and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
                    source = "biome",
                  })
                end
              end
            end
          end
          return diagnostics
        end,
      }),
    }

    null_ls.setup({
      sources = {
        biome_diagnostics,
        biome_formatting,

        null_ls.builtins.formatting.prettier.with({
          filetypes = { "html", "css", "scss", "markdown", "yaml" },
          condition = function(utils)
            return not utils.root_has_file({ "biome.json", "biome.jsonc" })
          end,
        }),

        null_ls.builtins.formatting.black.with({ filetypes = { "python" } }),
        null_ls.builtins.formatting.isort.with({ filetypes = { "python" } }),
        null_ls.builtins.formatting.stylua.with({ filetypes = { "lua" } }),
        null_ls.builtins.formatting.gofmt.with({ filetypes = { "go" } }),
      },

      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(c)
                  return c.name == "null-ls"
                end,
                timeout_ms = 2000,
              })
            end,
          })
        end
      end,

      debug = false,
    })
  end,
}
