local augroup = vim.api.nvim_create_augroup("AutoSpellFix", { clear = true })

vim.api.nvim_create_autocmd("InsertLeave", {
    group = augroup,
    pattern = { "*.txt", "*.md", "*.tex" },
    callback = function()
        if not vim.wo.spell then return end

        local win = vim.api.nvim_get_current_win()
        local row = vim.api.nvim_win_get_cursor(win)[1]

        -- Save cursor position via mark; Neovim updates it automatically as text changes
        vim.cmd('normal! mz')
        vim.api.nvim_win_set_cursor(win, { row, 0 })

        local function fix_if_valid()
            local bad_word = vim.fn.spellbadword()[1]
            if bad_word ~= "" and not bad_word:match("^%u+$") then
                vim.cmd('normal! 1z=')
            end
        end

        fix_if_valid()

        while true do
            local prev_pos = vim.api.nvim_win_get_cursor(win)
            vim.cmd('silent! normal! ]s')
            local curr_pos = vim.api.nvim_win_get_cursor(win)

            -- Stop if ]s left the current row or didn't move at all
            if curr_pos[1] ~= row
                or (curr_pos[1] == prev_pos[1] and curr_pos[2] == prev_pos[2]) then
                break
            end

            fix_if_valid()
        end

        -- Restore to the saved mark; clamp to end-of-line if the line shrank
        if not pcall(vim.cmd, 'normal! `z') then
            local line_len = #vim.api.nvim_get_current_line()
            pcall(vim.api.nvim_win_set_cursor, win, { row, math.max(0, line_len - 1) })
        end
    end,
})
