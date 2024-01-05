-- Lualine
require("lualine").setup({
    icons_enabled = true,
    theme = 'tokyonight',
})

-- Colorscheme
vim.cmd("colorscheme tokyonight")
vim.api.nvim_set_hl(0, "LineNr", { guifg=Grey })

-- Comment
require("Comment").setup()
