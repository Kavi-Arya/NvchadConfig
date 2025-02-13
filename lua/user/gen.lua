local M = {
  "David-Kunz/gen.nvim",
    event = "BufEnter",
  opts = {
    model = "deepseek-r1:8b",
    display_mode = "horizontal-split", -- The display mode. Can be "float" or "split" or "horizontal-split".
  },
  config = function()
    require("gen").setup({
      vim.keymap.set({ 'n', 'v' }, '<leader>gg', ':Gen<CR>'),
      vim.keymap.set('v', '<leader>gs', ':Gen Enhance_Grammar_Spelling<CR>'),
      vim.keymap.set('v', '<leader>gw', ':Gen Enhance_Wording<CR>'),
      vim.keymap.set('v', '<leader>ge', ':Gen Explain_Text<CR>'),
      vim.keymap.set('v', '<leader>gf', ':Gen Fix_Code<CR>'),
    })
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
