-- ~/.config/nvim/lua/markdown-commit-reminder.lua
--
-- Neovim Lua script to remind the user to commit changes
-- when writing Markdown files.

-- Initialize a flag to track if a markdown file was written during the session.
-- We use vim.g to make it global across Neovim's Lua environment for the session.
vim.g.markdown_was_written = false

-- Create a dedicated autocommand group to organize our commands.
-- This makes them easy to manage and clear (e.g., using :autocmd! MarkdownCommitReminder).
local group = vim.api.nvim_create_augroup("MarkdownCommitReminder", { clear = true })

-- Autocommand 1: Trigger after successfully writing a Markdown file.
vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  pattern = "*.md", -- Only trigger for files ending in .md
  desc = "Show commit reminder after saving a Markdown file",
  callback = function()
    -- Display a notification within Neovim.
    vim.notify(
      "Remember to commit changes!", -- The message
      vim.log.levels.INFO,           -- Severity level (INFO is standard)
      { title = "Markdown Saved" }   -- Optional title for the notification
    )
    -- Set the flag indicating a markdown file was written in this session.
    vim.g.markdown_was_written = true
  end,
})

-- Autocommand 2: Trigger just before Neovim exits.
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  pattern = "*", -- Trigger regardless of the current file
  desc = "Show terminal commit reminder if a Markdown file was saved",
  callback = function()
    -- Check if the flag was set by the BufWritePost autocommand.
    if vim.g.markdown_was_written then
      -- Use vim.fn.system() to execute a shell command.
      -- We run 'echo' in the background (&) after a tiny sleep
      -- to ensure Neovim has fully exited before the message appears.
      local cmd = " (sleep 0.1 && echo '\\n>>> Remember to commit your recently saved Markdown changes! <<<') &"
      vim.fn.system(cmd)

      -- Reset the flag for the next Neovim session (or if config is reloaded).
      -- This prevents the message from showing on exit if no markdown
      -- file was actually saved in the *current* session run.
      vim.g.markdown_was_written = false
    end
  end,
})
