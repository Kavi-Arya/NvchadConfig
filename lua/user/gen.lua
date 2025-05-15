local M = {
  "David-Kunz/gen.nvim",
    event = "BufEnter",
  opts = {
    model = "deepseek-r1:14b",
    display_mode = "split", -- The display mode. Can be "float" or "split" or "horizontal-split".
  },
  config = function()
    local keymap = vim.keymap.set
    local gen = require('gen')
    require("gen").setup({
      keymap({ 'n', 'v' }, '<leader>gg', ':Gen<CR>', { desc = 'Gen Menu' }),
      keymap('v', '<leader>gs', ':Gen Enhance_Grammar_Spelling<CR>', { desc = 'Enhance Grammar'}),
      keymap('v', '<leader>gw', ':Gen Enhance_Wording<CR>', { desc = 'Enhance Wording' }),
      keymap('v', '<leader>ge', ':Gen Explain_Text<CR>', { desc = 'Just Explain Text' }),
      keymap('v', '<leader>gf', ':Gen Fix_Code<CR>', { desc = 'Fix Code' }),
      keymap('v', '<leader>gt', ':Gen Format_in_LaTeX<CR>', { desc = 'Format in LaTeX' }),
      keymap('v', '<leader>gE', ':Gen Elaborate_Text<CR>', { desc = 'Elaborate Text and change' }),
      keymap({'n', 'v' }, '<leader>gm', ':lua require("gen").select_model()<CR>', { desc = 'Select Model' }),
    })
    require('gen').prompts['Format_in_LaTeX'] = {
      prompt = "Format the following text in Latex, do not change the content, do not include any preamble, no need to include usepackage or documentclass or begindocument ,use sections, subsections, subsubsections, paragraphs, enumerate and itemize for lists, also make table then needed, just the formated output, just output the final text without additional quotes around it:\n$text",
      replace = true
    }
    require('gen').prompts['Format_in_Markdown'] = {
      prompt = "Format the following text in Markdown, just the formated output, use headings with '#','##','###', and for bullet lists use '- ', Do no change the content, just output the final text without additional quotes around it:\n$text",
      replace = true
    }
    require('gen').prompts['Elaborate_Text'] = {
      prompt = "Elaborate the following text, just output the final text without additional quotes around it:\n$text",
      replace = true
    }
    require('gen').prompts['Explain_Text'] = {
      prompt = "Explain the following text:\n$text",
      replace = false
    }
    require('gen').prompts['Fix_Code'] = {
      prompt = "Fix the following code. Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
      replace = true,
      extract = "```$filetype\n(.-)```"
    }
  end
}
return M
