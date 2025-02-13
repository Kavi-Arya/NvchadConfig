local M ={
  'milanglacier/minuet-ai.nvim',
  'nvim-lua/plenary.nvim',
  'hrsh7th/nvim-cmp',
  config = function()
    require('minuet').setup {
      event = "BufEnter",
      provider = 'openai_fim_compatible',
      n_completions = 1, -- recommend for local model for resource saving
      -- I recommend you start with a small context window firstly, and gradually
      -- increase it based on your local computing power.
      context_window = 512,
      provider_options = {
        openai_fim_compatible = {
          api_key = 'TERM',
          name = 'Ollama',
          end_point = 'http://localhost:11434/v1/completions',
          model = 'mistral',
          optional = {
            max_tokens = 256,
            top_p = 0.9,
          },
        },
      },
      virtualtext = {
        auto_trigger_ft = {},
        keymap = {
          -- accept whole completion
          accept = '<A-A>',
          -- accept one line
          accept_line = '<A-a>',
          -- accept n lines (prompts for number)
          accept_n_lines = '<A-z>',
          -- Cycle to prev completion item, or manually invoke completion
          prev = '<A-[>',
          -- Cycle to next completion item, or manually invoke completion
          next = '<A-]>',
          dismiss = '<A-e>',
        }
      }
    }
  end
}
return M
