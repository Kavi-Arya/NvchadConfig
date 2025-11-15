--[[
  A simple Neovim plugin to automatically write the buffer
  when leaving insert mode and entering normal mode.
--]]

-- Create a dedicated augroup to prevent autocmd duplication
-- This ensures that if you reload your configuration, the autocommand
-- doesn't get created a second time.
local autoWriteGroup = vim.api.nvim_create_augroup("AutoWriteOnNormal", { clear = true })

-- Create the autocommand
vim.api.nvim_create_autocmd("ModeChanged", {
  group = autoWriteGroup,
  -- Pattern: Match transitions from any Insert mode ('i', 'ic', 'ix')
  -- to any Normal mode ('n', 'ni', 'no').
  pattern = "i:* -> n:*",
  desc = "Write buffer when entering normal mode from insert mode",
  callback = function()
    -- Check if the buffer has a file associated with it and is readable.
    -- This prevents errors when you are in a new, unnamed buffer.
    if vim.fn.filereadable(vim.fn.expand('%')) == 1 and vim.bo.modified then
      -- Using vim.cmd('write') is a safe and simple way to save.
      -- It's equivalent to typing ":w" and pressing Enter.
      vim.cmd('write')
    end
  end,
})

print("Auto-write plugin loaded successfully.")

