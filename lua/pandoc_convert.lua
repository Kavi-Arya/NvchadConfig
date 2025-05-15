-- Define a function to convert the current buffer (Markdown) to PDF using Pandoc
local function md_to_pdf_pandoc()
    -- Get the full path of the current buffer's file
    local current_file = vim.api.nvim_buf_get_name(0)

    -- Check if the current buffer has a file associated with it
    if current_file == "" then
        print("Error: Current buffer is not associated with a file.")
        return
    end

    -- Get the directory of the current file
    local file_dir = vim.fn.fnamemodify(current_file, ':h')

    -- Define the path for the pdfs directory
    local pdfs_dir = file_dir .. '/pdfs'

    -- Check if the pdfs directory exists, and create it if it doesn't
    if vim.fn.isdirectory(pdfs_dir) == 0 then
        print("Creating directory: " .. pdfs_dir)
        -- 'p' flag creates parent directories if necessary
        vim.fn.mkdir(pdfs_dir, 'p')
    end

    -- Prompt the user for the desired PDF filename
    local pdf_filename = vim.fn.input('Enter PDF filename (without .pdf): ')

    -- Check if the user provided a filename
    if pdf_filename == "" then
        print("PDF filename cannot be empty. Aborting.")
        return
    end

    -- Construct the full path for the output PDF file
    local output_pdf_path = pdfs_dir .. '/' .. pdf_filename .. '.pdf'

    -- Construct the Pandoc command
    -- Basic command: pandoc input.md -o output.pdf
    -- You can add more options here, e.g., --standalone, --css, --template, etc.
    -- local pandoc_command = string.format('pandoc "%s" -o "%s"', current_file, output_pdf_path)
    local pandoc_command = string.format('pandoc "%s" --template=double-two-column.tex -o "%s"', current_file, output_pdf_path)


    print("Executing Pandoc command: " .. pandoc_command)

    -- Execute the Pandoc command asynchronously to avoid freezing Neovim
    -- Using vim.fn.system() is simpler for basic execution and capturing output/status
    local result = vim.fn.system(pandoc_command)
    local status = vim.v.shell_error -- Check the exit status of the last shell command

    -- Check the status code to see if Pandoc succeeded
    if status == 0 then
        print("Successfully converted " .. current_file .. " to " .. output_pdf_path)
    else
        print("Error during Pandoc conversion. Status code: " .. status)
        print("Pandoc output/error: \n" .. result)
    end
end

-- Create a Neovim command that calls the Lua function
-- The ! allows the command to be run even if there are unsaved changes
vim.api.nvim_create_user_command('MdToPdf', md_to_pdf_pandoc, { nargs = 0, desc = 'Convert current Markdown file to PDF using Pandoc' })

-- You can optionally create a keymap for convenience, e.g., map <leader>p to :MdToPdf<CR>
vim.api.nvim_set_keymap('n', '<leader>pd', ':MdToPdf<CR>', { noremap = true, silent = true })
