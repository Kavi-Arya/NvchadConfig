local function md_to_pdf_pandoc()
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == "" then
        print("Error: Current buffer is not associated with a file.")
        return
    end
    local file_dir = vim.fn.fnamemodify(current_file, ':h')
    local pdfs_dir = file_dir .. '/pdfs'
    if vim.fn.isdirectory(pdfs_dir) == 0 then
        print("Creating directory: " .. pdfs_dir)
        vim.fn.mkdir(pdfs_dir, 'p')
    end
    local pdf_filename = vim.fn.input('Enter PDF filename (without .pdf): ')
    if pdf_filename == "" then
        print("PDF filename cannot be empty. Aborting.")
        return
    end
    local output_pdf_path = pdfs_dir .. '/' .. pdf_filename .. '.pdf'

    -- Construct the Pandoc command
    -- Basic command: pandoc input.md -o output.pdf
    -- You can add more options here, e.g., --standalone, --css, --template, etc.
    -- local pandoc_command = string.format('pandoc "%s" -o "%s"', current_file, output_pdf_path)
    local pandoc_command = string.format('pandoc "%s" --template=double-two-column.tex -o "%s"', current_file, output_pdf_path)


    print("Executing Pandoc command: " .. pandoc_command)

    local result = vim.fn.system(pandoc_command)
    local status = vim.v.shell_error
    if status == 0 then
        print("Successfully converted " .. current_file .. " to " .. output_pdf_path)
    else
        print("Error during Pandoc conversion. Status code: " .. status)
        print("Pandoc output/error: \n" .. result)
    end
end

vim.api.nvim_create_user_command('MdToPdf', md_to_pdf_pandoc, { nargs = 0, desc = 'Convert current Markdown file to PDF using Pandoc' })
vim.api.nvim_set_keymap('n', '<leader>pd', ':MdToPdf<CR>', { noremap = true, silent = true })
