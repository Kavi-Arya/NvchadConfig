local M = {
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
}

function M.config()
  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true }

  keymap("n", "<s-m>", "<cmd>lua require('user.harpoon').mark_file()<cr>", opts)
  keymap("n", "<TAB>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
  keymap("n", "<S-n>", "<cmd>lua require('harpoon.ui').nav_next()<cr>", opts)
  keymap("n", "<S-p>", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", opts)


  vim.api.nvim_create_autocmd({ "filetype" }, {
    pattern = "harpoon",
    callback = function()
      vim.cmd [[highlight link HarpoonBorder TelescopeBorder]]
      -- vim.cmd [[setlocal nonumber]]
      -- vim.cmd [[highlight HarpoonWindow guibg=#313132]]
    end,
  })
end

function M.mark_file()
  require("harpoon.mark").add_file()
  vim.notify "󱡅  marked file"
end

return M
