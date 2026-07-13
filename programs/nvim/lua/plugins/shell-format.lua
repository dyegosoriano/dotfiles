-- Formatting rules for shell scripts.
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        fish = { "fish_indent" },
        sh = { "shfmt" },
      })

      opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
        fish_indent = {
          command = "fish_indent",
        },
        shfmt = {
          prepend_args = { "-i", "2", "-ci", "-sr", "-bn", "-ln", "bash" },
        },
      })
    end,
  },
}
