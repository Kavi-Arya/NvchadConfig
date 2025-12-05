local function md_to_pdf_pandoc()
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == "" then
        vim.notify("Buffer has no file path.", vim.log.levels.ERROR)
        return
    end

    local file_dir = vim.fn.fnamemodify(current_file, ':h')
    local pdfs_dir = file_dir .. '/pdfs'
    local filename_root = vim.fn.fnamemodify(current_file, ':t:r')

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
                    else
                        local error_msg = table.concat(stderr_chunks, "\n")
                        on_failure(error_msg)
                    end
            local open_cmd
            if vim.fn.has("mac") == 1 then
              open_cmd = {"open", output_pdf_path}
            elseif vim.fn.has("unix") == 1 then
              open_cmd = {"xdg-open", output_pdf_path}
            elseif vim.fn.has("win32") == 1 then
              open_cmd = {"cmd", "/c", "start", "", output_pdf_path}
            end
            if open_cmd then vim.fn.jobstart(open_cmd) end
                end
            }
        end

        -- DEFINITION: The Fallback Job (No Template)
        local function run_fallback()
            vim.notify("Template failed. Retrying with default Pandoc...", vim.log.levels.WARN)
            
            local args_default = {'pandoc', current_file, '-o', output_pdf_path}
            
            vim.fn.jobstart(args_default, create_handlers(
                function() -- Success
                    vim.notify("Success! (Used default format): " .. output_pdf_path, vim.log.levels.INFO)
                end,
                function(err_msg) -- Failure
                    vim.notify("Default conversion also failed:\n" .. err_msg, vim.log.levels.ERROR)
                end
            ))
        end

        -- EXECUTION: The Primary Job (With Template)
        vim.notify("Compiling PDF (with template)...", vim.log.levels.INFO)
        
        local args_template = {
            'pandoc', 
            current_file, 
            '--template=double-two-column.tex', 
            '-o', 
            output_pdf_path
        }

        vim.fn.jobstart(args_template, create_handlers(
            function() -- Success
                vim.notify("Success! (Used custom template): " .. output_pdf_path, vim.log.levels.INFO)
            end,
            function(err_msg) -- Failure
                -- Log the specific template error to :messages for debugging, but don't popup a huge error yet
                vim.api.nvim_echo({{ "Template error: " .. err_msg, "WarningMsg" }}, true, {})
                -- Trigger the fallback
                run_fallback() 
            end
        ))
    end)
end

vim.api.nvim_create_user_command('MdToPdf', md_to_pdf_pandoc, { nargs = 0, desc = 'Convert MD to PDF (Auto-fallback)' })
vim.keymap.set('n', '<leader>pd', ':MdToPdf<CR>', { noremap = true, silent = true, desc = "Convert MD to PDF" })
