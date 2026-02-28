return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
  settings = {
    Lua = {
      diagnostics = {
        -- Tell the LSP to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
   }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "markdown", "markdown_inline", "bash", "python","rust"

      },
    },
  },

  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),       -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },           -- tags
          d = { "%f[%d]%d+" },                                                          -- digits
          e = {                                                                         -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          -- g = LazyVim.mini.ai_buffer, -- buffer
          u = ai.gen_spec.function_call(),                           -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },

  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
  },

  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },

  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>",                  desc = "Symbols (Trouble)" },
      { "<leader>cS", "<cmd>Trouble lsp toggle<cr>",                      desc = "LSP references/definitions/... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Trouble/Quickfix Item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix Item",
      },
    },
  },

  {
    "folke/snacks.nvim",
    opts = {
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      -- scroll = { enabled = true },
      statuscolumn = { enabled = false }, -- we set this in options.lua
      -- toggle = { map = LazyVim.safe_keymap_set },
      words = { enabled = true },
    },
    -- stylua: ignore
  },

  -- {
  --   "tzachar/cmp-ai",
  --   enabled = false,
  --   dependencies = "nvim-lua/plenary.nvim",
  --   config = function()
  --     local cmp_ai = require("cmp_ai.config")
  --
  --     cmp_ai:setup {
  --       max_lines = 1000,
  --       notify = false,
  --       notify_callback = function(msg)
  --         vim.notify(msg)
  --       end,
  --       run_on_every_keystroke = true,
  --       ignored_file_types = {
  --         TelescopePrompt = true,
  --       },
  --       -- provider = ollama
  --       provider = "Ollama",
  --       provider_options = {
  --         model = "mistral:latest",
  --       },
  --     }
  --   end,
  -- },
  -- {
  --   "sainnhe/gruvbox-material",
  --   event = "VeryLazy"
  -- },
  -- {
  --   "LunarVim/darkplus.nvim",
  --   event = "VeryLazy"
  -- },

  -- {
  --   "github/copilot.vim",
  --   event = "VeryLazy"
  -- },
  
-- In your lazy.nvim plugin specification for fugitive
-- e.g., lua/plugins/fugitive.lua or in your main plugins table

  {
    'tpope/vim-fugitive',
    event = "VeryLazy",
    config = function()
    end,
    keys = {
      {
        "<leader>gaA",
        function()
          vim.cmd("Git add *")
          vim.notify("Add all files", vim.log.levels.INFO)
        end,
        desc = "Git add all",
      },
      {
        "<leader>gaa",
        function()
          vim.cmd("Git add %")
          vim.notify("Add current file", vim.log.levels.INFO)
        end,
        desc = "Git add current file",
      },
      -- Alternative for staging: using :Gwrite (writes and stages the current buffer)
      -- {
      --   "<leader>gs", -- "git stage"
      --   ":Gwrite<CR>",
      --   noremap = true,
      --   silent = true,
      --   desc = "Git stage current file (Gwrite)",
      -- },

      -- Keybinding for :Git commit
      -- Example: <leader>gc for "git commit"
      {
        "<leader>gc",
        ":Git commit<CR>",
        noremap = true,
        silent = true,
        desc = "Git commit",
      },

      -- Keybinding for :Git push
      -- Example: <leader>gp for "git push"
      {
        "<leader>gp",
        ":Git push<CR>",
        noremap = true,
        silent = true,
        desc = "Git push",
      },

      -- Keybinding to open Git status window
      -- Example: <leader>gs for "git status" (if not used for Gwrite)
      {
        "<leader>gst", -- Differentiating from potential 'gs' for Gwrite
        ":Git<CR>",
        noremap = true,
        silent = true,
        desc = "Git status (Fugitive window)",
      },
    },
  },

  {
    'kiddos/gemini.nvim',
    event = "VeryLazy",
    config = function()
      require('gemini').setup({
        model_config = {
          model_id = 'gemini-3-pro-preview',
          temperature = 0.10,
          top_k = 128,
          response_mime_type = 'text/plain',
        },

        completion = {
          insert_result_key = '<Tab>'
        }
      })
    end
  },

  {
    "chrisgrieser/nvim-origami",
    event = "VeryLazy",
    -- config = function()
    --   require('nvim-origami').setup({
    --     vim.keymap.set("n", "<Left>", function() require("origami").h() end)
    --     vim.keymap.set("n", "<Right>", function() require("origami").l() end)
    --   })
    -- end,
    opts = {}, -- needed even when using default config
  },

--   {
--    "m4xshen/hardtime.nvim",
--    lazy = false,
--    dependencies = { "MunifTanjim/nui.nvim" },
--    opts = {},
-- },

  require "user.obsidian",
  require "user.contex",
  require "user.harpoon",
  require "user.minimap",
  require "user.vimtex",
  require "user.texpresso",
  require "user.codeium",
  require "user.gen",
  -- require "user.codecomplition",
  require "user.undotree",
  require "user.marvim",
  require "user.render-markdown",
  require "user.colorscheme",
  -- require "user.autofold",
  -- require "user.cmp_ai",
  -- require "user.whichkey",
}
