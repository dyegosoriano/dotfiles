-- https://github.com/yetone/avante.nvim
-- if true then return {} end

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  opts = {
    cursor_applying_provider = 'groq_llama3', -- https://github.com/yetone/avante.nvim/blob/main/cursor-planning-mode.md
    behaviour = { enable_cursor_planning_mode = true },
    auto_suggestions_provider = "groq_mistral",
    provider = "openai",

    -- https://github.com/yetone/avante.nvim/wiki
    providers = {
      claude = {
        extra_request_body = { max_tokens = 8192, temperature = 0 },
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-20250514",
        timeout = 30000,
      },
      openai = {
        extra_request_body = { max_tokens = 8192, temperature = 0 },
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4.1-mini",
        timeout = 30000,
      },
      -- ollama = {
      --   extra_request_body = { options = { temperature = 0.75, keep_alive = "5m", num_ctx = 20480, }, },
      --   endpoint = "http://127.0.0.1:11434",
      --   timeout = 30000,
      -- },
      groq_gpt_oss_120b = {
        extra_request_body = { max_tokens = 32768, temperature = 0 },
        endpoint = 'https://api.groq.com/openai/v1/',
        model = 'openai/gpt-oss-120b',
        api_key_name = 'GROQ_API_KEY',
        __inherited_from = 'openai',
        disable_tools = true,
      },
      groq_gpt_oss_20b = {
        extra_request_body = { max_tokens = 32768, temperature = 0 },
        endpoint = 'https://api.groq.com/openai/v1/',
        model = 'openai/gpt-oss-20b',
        api_key_name = 'GROQ_API_KEY',
        __inherited_from = 'openai',
        disable_tools = true,
      },
      groq_llama3 = {
        extra_request_body = { max_tokens = 32768, temperature = 0 },
        endpoint = 'https://api.groq.com/openai/v1/',
        model = 'llama-3.3-70b-versatile',
        api_key_name = 'GROQ_API_KEY',
        __inherited_from = 'openai',
        disable_tools = true,
      },
      groq_llama4 = {
        extra_request_body = { max_tokens = 32768, temperature = 0 },
        endpoint = 'https://api.groq.com/openai/v1/',
        model = "meta-llama/llama-4-maverick-17b-128e-instruct",
        api_key_name = 'GROQ_API_KEY',
        __inherited_from = 'openai',
        disable_tools = true,
      },
      groq_deepseek = {
        extra_request_body = { max_tokens = 32768, temperature = 0 },
        endpoint = 'https://api.groq.com/openai/v1/',
        model = "deepseek-r1-distill-llama-70b",
        api_key_name = 'GROQ_API_KEY',
        __inherited_from = 'openai',
        disable_tools = true,
      },
      groq_mistral = {
        extra_request_body = { max_tokens = 32768, temperature = 0 },
        endpoint = 'https://api.groq.com/openai/v1/',
        model = "mistral-saba-24b",
        api_key_name = 'GROQ_API_KEY',
        __inherited_from = 'openai',
        disable_tools = true,
      },
    },
    system_prompt = function()
      local hub = require("mcphub").get_hub_instance()
      return hub and hub:get_active_servers_prompt() or ""
    end,
    custom_tools = function()
      return {
        require("mcphub.extensions.avante").mcp_tool(),
      }
    end,
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
