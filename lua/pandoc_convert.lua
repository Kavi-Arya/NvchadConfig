local function md_to_pdf_pandoc()
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == "" then
        vim.notify("Buffer has no file path.", vim.log.levels.ERROR)
        return
    end

    local file_dir = vim.fn.fnamemodify(current_file, ':h')
    local pdfs_dir = file_dir .. '/pdfs'
    local filename_root = vim.fn.fnamemodify(current_file, ':t:r')

    -- Ensure 'pdfs' directory exists
    if vim.fn.isdirectory(pdfs_dir) == 0 then
        vim.fn.mkdir(pdfs_dir, 'p')
    end

    vim.ui.input({
        prompt = 'Output PDF name: ',
        default = filename_root,
        completion = 'file'
    }, function(input)
        if input == nil or input == "" then return end

        local output_pdf_path = pdfs_dir .. '/' .. input .. '.pdf'

        -- 1. Helper: Open PDF based on OS
        local function open_pdf(path)
            local open_cmd
            if vim.fn.has("mac") == 1 then
                open_cmd = { "open", path }
            elseif vim.fn.has("unix") == 1 then
                open_cmd = { "xdg-open", path }
            elseif vim.fn.has("win32") == 1 then
                open_cmd = { "cmd", "/c", "start", "", path }
            end
            
            if open_cmd then 
                vim.fn.jobstart(open_cmd, { detach = true }) 
            else
                vim.notify("Could not determine command to open PDF.", vim.log.levels.WARN)
            end
        end

        -- 2. Helper: The Core Compilation Logic
        -- We wrap this in a function so we can call it either immediately
        -- OR after the user confirms they want to update.
        local function start_compilation()
            
            -- Handler creation (reused for both template and fallback)
            local function create_handlers(on_success, on_failure)
                local stderr_chunks = {}
                return {
                    stdout_buffered = true,
                    stderr_buffered = true,
                    on_stderr = function(_, data)
                        if data then
                            for _, line in ipairs(data) do
                                if line ~= "" then table.insert(stderr_chunks, line) end
                            end
                        end
                    end,
                    on_exit = function(_, code)
                        if code == 0 then
                            on_success()
                            open_pdf(output_pdf_path) -- Open newly created/updated file
                        else
                            local error_msg = table.concat(stderr_chunks, "\n")
                            on_failure(error_msg)
                        end
                    end
                }
            end

            -- The Fallback Job (No Template)
            local function run_fallback()
                vim.notify("Template failed. Retrying with default Pandoc...", vim.log.levels.WARN)
                local args_default = { 'pandoc', current_file, '-o', output_pdf_path }
                
                vim.fn.jobstart(args_default, create_handlers(
                    function() 
                        vim.notify("Success! (Used default format): " .. output_pdf_path, vim.log.levels.INFO)
                    end,
                    function(err_msg) 
                        vim.notify("Default conversion also failed:\n" .. err_msg, vim.log.levels.ERROR)
                    end
                ))
            end

            -- The Primary Job (With Template)
            vim.notify("Compiling PDF...", vim.log.levels.INFO)
            local args_template = {
                'pandoc', current_file, '--template=arabica.latex', '-o', output_pdf_path
                -- 'pandoc', current_file, '--template=double-two-column.tex', '-o', output_pdf_path
            }

            vim.fn.jobstart(args_template, create_handlers(
                function()
                    vim.notify("Success! (Used custom template): " .. output_pdf_path, vim.log.levels.INFO)
                end,
                function(err_msg)
                    vim.api.nvim_echo({ { "Template error: " .. err_msg, "WarningMsg" } }, true, {})
                    run_fallback()
                end
            ))
        end

        -- 3. Main Logic: Check if file exists and ask user
        if vim.fn.filereadable(output_pdf_path) == 1 then
            vim.ui.select(
                { 'No (Open Existing)', 'Yes (Update/Overwrite)' },
                { prompt = 'PDF exists. Update file?' },
                function(choice)
                    if choice == 'Yes (Update/Overwrite)' then
                        -- User chose to update: Compile (overwrites automatically)
                        start_compilation()
                    elseif choice == 'No (Open Existing)' then
                        -- User chose not to update: Just open
                        vim.notify("Opening existing PDF...", vim.log.levels.INFO)
                        open_pdf(output_pdf_path)
                    else
                        -- User cancelled (Esc)
                        vim.notify("Action cancelled.", vim.log.levels.INFO)
                    end
                end
            )
        else
            -- File does not exist: Create it immediately
            start_compilation()
        end
    end)
end

vim.api.nvim_create_user_command('MdToPdf', md_to_pdf_pandoc, { nargs = 0, desc = 'Convert MD to PDF (Auto-fallback)' })
vim.keymap.set('n', '<leader>pd', ':MdToPdf<CR>', { noremap = true, silent = true, desc = "Convert MD to PDF" })
