local M = {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
  lazy = false,
  init = function()
    require('render-markdown').setup({
      heading = {
        -- Turn on / off heading icon & background rendering
        enabled = true,
        -- Additional modes to render headings
        render_modes = false,
        -- Turn on / off any sign column related rendering
        sign = true,
        -- Replaces '#+' of 'atx_h._marker'
        -- The number of '#' in the heading determines the 'level'
        -- The 'level' is used to index into the list using a cycle
        -- If the value is a function the input context contains the nesting level of the heading within sections
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        -- Determines how icons fill the available space:
        --  right:   '#'s are concealed and icon is appended to right side
        --  inline:  '#'s are concealed and icon is inlined on left side
        --  overlay: icon is left padded with spaces and inserted on left hiding any additional '#'
        position = 'overlay',
        -- Added to the sign column if enabled
        -- The 'level' is used to index into the list using a cycle
        signs = { '󰫎 ' },
        -- Width of the heading background:
        --  block: width of the heading text
        --  full:  full width of the window
        -- Can also be a list of the above values in which case the 'level' is used
        -- to index into the list using a clamp
        width = 'full',
        -- Amount of margin to add to the left of headings
        -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
        -- Margin available space is computed after accounting for padding
        -- Can also be a list of numbers in which case the 'level' is used to index into the list using a clamp
        left_margin = 0,
        -- Amount of padding to add to the left of headings
        -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
        -- Can also be a list of numbers in which case the 'level' is used to index into the list using a clamp
        left_pad = 0,
        -- Amount of padding to add to the right of headings when width is 'block'
        -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
        -- Can also be a list of numbers in which case the 'level' is used to index into the list using a clamp
        right_pad = 1,
        -- Minimum width to use for headings when width is 'block'
        -- Can also be a list of integers in which case the 'level' is used to index into the list using a clamp
        min_width = 0,
        -- Determines if a border is added above and below headings
        -- Can also be a list of booleans in which case the 'level' is used to index into the list using a clamp
        border = false,
        -- Always use virtual lines for heading borders instead of attempting to use empty lines
        border_virtual = false,
        -- Highlight the start of the border using the foreground highlight
        border_prefix = false,
        -- Used above heading for border
        above = '▄',
        -- Used below heading for border
        below = '▀',
        -- The 'level' is used to index into the list using a clamp
        -- Highlight for the heading icon and extends through the entire line
        backgrounds = {
          'RenderMarkdownH1Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH3Bg',
          'RenderMarkdownH4Bg',
          'RenderMarkdownH5Bg',
          'RenderMarkdownH6Bg',
        },
        -- The 'level' is used to index into the list using a clamp
        -- Highlight for the heading and sign icons
        foregrounds = {
          'RenderMarkdownH1',
          'RenderMarkdownH2',
          'RenderMarkdownH3',
          'RenderMarkdownH4',
          'RenderMarkdownH5',
          'RenderMarkdownH6',
        },
        -- Define custom heading patterns which allow you to override various properties
        -- based on the contents of a heading. Each entry should consist of a string key,
        -- which is used mostly as an identifier, and a table value with:
        --   'pattern':    Matched against the heading text see :h lua-pattern
        --   'icon':       Optional override for the icon
        --   'background': Optional override for the background
        --   'foreground': Optional override for the foreground
        custom = {},
      },

      bullet = {
        -- Turn on / off list bullet rendering
        enabled = true,
        -- Additional modes to render list bullets
        render_modes = true,
        -- Replaces '-'|'+'|'*' of 'list_item'
        -- How deeply nested the list is determines the 'level', how far down at that level determines the 'index'
        -- If a function is provided both of these values are provided in the context using 1 based indexing
        -- If a list is provided we index into it using a cycle based on the level
        -- If the value at that level is also a list we further index into it using a clamp based on the index
        -- If the item is a 'checkbox' a conceal is used to hide the bullet instead
        icons = { '●', '○', '◆', '◇' },
        -- Replaces 'n.'|'n)' of 'list_item'
        -- How deeply nested the list is determines the 'level', how far down at that level determines the 'index'
        -- If a function is provided both of these values are provided in the context using 1 based indexing
        -- If a list is provided we index into it using a cycle based on the level
        -- If the value at that level is also a list we further index into it using a clamp based on the index
        ordered_icons = function(ctx)
          local value = vim.trim(ctx.value)
          local index = tonumber(value:sub(1, #value - 1))
          return string.format('%d.', index > 1 and index or ctx.index)
        end,
        -- Padding to add to the left of bullet point
        left_pad = 0,
        -- Padding to add to the right of bullet point
        right_pad = 1,
        -- Highlight for the bullet icon
        highlight = 'RenderMarkdownBullet',
      },
      dash = {
        -- Turn on / off thematic break rendering
        enabled = true,
        -- Additional modes to render dash
        render_modes = false,
        -- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'
        -- The icon gets repeated across the window's width
        icon = '─',
        -- Width of the generated line:
        --  <number>: a hard coded width value, if a floating point value < 1 is provided it is
        --            treated as a percentage of the available window space
        --  full:     full width of the window
        width = 'full',
        -- Amount of margin to add to the left of dash
        -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
        left_margin = 0,
        -- Highlight for the whole line generated from the icon
        highlight = 'RenderMarkdownDash',
      },
      paragraph = {
        -- Turn on / off paragraph rendering
        enabled = true,
        -- Additional modes to render paragraphs
        render_modes = false,
        -- Amount of margin to add to the left of paragraphs
        -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
        left_margin = 0,
        -- Minimum width to use for paragraphs
        min_width = 0,
      },


    })
  end
}
return M
