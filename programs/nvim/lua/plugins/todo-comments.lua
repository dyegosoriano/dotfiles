-- https://github.com/folke/todo-comments.nvim
-- if true then return {} end

return {
  "folke/todo-comments.nvim",
  opts = {
    sign_priority = 8,
    signs = true,
    keywords = {
      FIX = {
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        color = "error",
        icon = " ",
      },
      TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      HACK = { icon = " ", color = "warning" },
      TODO = { icon = " ", color = "info" },
    },
    colors = {
      warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
      error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
      info = { "DiagnosticInfo", "#2563EB" },
      hint = { "DiagnosticHint", "#10B981" },
      default = { "Identifier", "#7C3AED" },
      test = { "Identifier", "#FF00FF" }
    },
  },
}
