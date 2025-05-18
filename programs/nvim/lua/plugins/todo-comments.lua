-- https://github.com/folke/todo-comments.nvim
-- if true then return {} end

return {
  "folke/todo-comments.nvim",
  opts = {
    keywords = {
      WARN = { icon = "⚠️ ", color = "warning", alt = { "WARNING", "XXX" } },
      HACK = { icon = "⚡", color = "warning" },
      TODO = { icon = "📝", color = "info" },
      FIX = { icon = "🔧", color = "error" },
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
