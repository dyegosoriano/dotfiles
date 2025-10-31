
return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = false },
      ensure_installed = {
        'markdown_inline',
        'javascript',
        'typescript',
        'markdown',
        'python',
        'query',
        'regex',
        'scss',
        'json',
        'bash',
        'yaml',
        'html',
        'vim',
        'tsx',
        'css',
        'lua',
      },
    },
  }
}
