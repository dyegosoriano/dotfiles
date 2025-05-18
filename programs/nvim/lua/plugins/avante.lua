-- https://github.com/yetone/avante.nvim
-- if true then return {} end

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  opts = {
    -- auto_suggestions_provider = "local_ollama",
    provider = "groq",
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-3-5-sonnet-20241022",
      max_tokens = 4096,
      temperature = 0,
    },
    openai = {
      --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      endpoint = "https://api.openai.com/v1",
      max_completion_tokens = 4096,
      model = "gpt-4o",
      temperature = 0,
      timeout = 30000,
    },
    -- https://github.com/yetone/avante.nvim/wiki/Custom-providers
    vendors = {
      groq = {
        endpoint = "https://api.groq.com/openai/v1",
        model = "meta-llama/llama-4-maverick-17b-128e-instruct",
        api_key_name = "GROQ_API_KEY",
        __inherited_from = "openai",
        max_tokens = 4096,
        temperature = 0,
      },
      local_ollama = {
        endpoint = "http://127.0.0.1:11434/v1",
        model = "codegemma",
        __inherited_from = "openai",
        disable_tools = true,
        max_tokens = 4096,
        temperature = 0,
      },
    },
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",

    -- --- The below dependencies are optional,
    -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
    -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
    -- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'

    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          drag_and_drop = { insert_mode = true },
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          use_absolute_path = true,
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = { file_types = { "markdown", "Avante" } },
      ft = { "markdown", "Avante" },
    },
  },
}
