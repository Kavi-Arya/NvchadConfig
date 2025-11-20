vim.o.viewoptions = "folds,cursor,curdir"

local view_group = vim.api.nvim_create_augroup("AutoSaveFolds", { clear = true })

vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost" }, {
    group = view_group,
    pattern = "*",
    callback = function()
        -- Try to save, but suppress errors (e.g., for read-only files or unnamed buffers)
        pcall(vim.cmd, "mkview")
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = view_group,
    pattern = "*",
    callback = function()
        -- Silent load to avoid errors if no view exists yet
        vim.cmd("silent! loadview")
    end,
})
