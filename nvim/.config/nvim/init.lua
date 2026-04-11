-- Configure leader
vim.g.mapleader = " "
vim.g.maplocalleader = "-"
vim.keymap.set("n", "<Space>", "<NOP>", { silent = true })
vim.keymap.set("n", "-", "<NOP>", { silent = true })

-- General Editor Configuration
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes:1"
vim.opt.mouse = "a"
vim.opt.scrolloff = 10
vim.opt.mousemoveevent = true
vim.opt.exrc = true

-- Color
vim.opt.termguicolors = true
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function() vim.hl.on_yank({ timeout = 300 }) end,
})

-- Buffer management
vim.opt.hidden = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showmatch = true

vim.opt.backspace = { "indent", "eol", "start" }

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.colorcolumn = "80"

vim.keymap.set("n", "j", "gj", { silent = true })
vim.keymap.set("n", "k", "gk", { silent = true })

-- Recovery
-- TODO(alvaro): Recovery
-- set noswapfile
-- set nobackup
-- set nowritebackup

-- Folding
vim.opt.foldenable = true
vim.opt.foldlevelstart = 10
vim.opt.foldnestmax = 10
vim.opt.foldmethod = "indent"

-- Built-in opt plugins
vim.cmd.packadd("nvim.undotree")

-- Eye candy
vim.opt.winborder = "rounded"

-- General Editing
vim.keymap.set("n", "<Leader>h", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<Leader>u", "viWUE")

-- vim.keymap.set("n", "<Leader>td", "mz:%s/\s\+$//<CR>`z")
vim.keymap.set("n", "<leader>td", function()
  local view = vim.fn.winsaveview()
  vim.cmd([[ silent g/\s\+$/s/\s*$// ]])
  vim.cmd([[ nohlsearch ]])
  vim.fn.winrestview(view)
end, { silent = true })

-- Clipboard
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "<Leader>yy", ":%y+<CR>")
vim.keymap.set("n", "<Leader>yap", 'vap"+y')

-- Window Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Buffer Navigation
vim.keymap.set("n", "gb", ":bn<CR>", { silent = true })
vim.keymap.set("n", "gB", ":bp<CR>", { silent = true })
vim.keymap.set("n", "<LocalLeader>b", ":b#<CR>", { silent = true })

-- Window Resize
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", { silent = true })
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", { silent = true })
vim.keymap.set("n", "<Right>", ":resize +2<CR>", { silent = true })
vim.keymap.set("n", "<Left>", ":resize -2<CR>", { silent = true })

-- Command Mode Niceties
vim.keymap.set("c", "<C-a>", "<C-b>")
vim.keymap.set("c", "<M-b>", "<S-Left>", { noremap = true }) -- This is actually <M-Left>
vim.keymap.set("c", "<M-f>", "<S-Right>", { noremap = true }) -- This is actually <M-Ritgh>

-- Common typos when exiting or saving
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("Q", "q", {})

-- Quickfix List movements
vim.keymap.set("n", "<LocalLeader>cn", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "<LocalLeader>cp", ":cprev<CR>", { silent = true })
vim.keymap.set("n", "<LocalLeader>co", ":copen<CR>", { silent = true })
vim.keymap.set("n", "<LocalLeader>cc", ":cclose<CR>", { silent = true })

-- Location List movements
vim.keymap.set("n", "<LocalLeader>ln", ":lnext<CR>", { silent = true })
vim.keymap.set("n", "<LocalLeader>lp", ":lprev<CR>", { silent = true })
vim.keymap.set("n", "<LocalLeader>lo", ":lopen<CR>", { silent = true })
vim.keymap.set("n", "<LocalLeader>lc", ":lclose<CR>", { silent = true })

-- Lua Execution
vim.keymap.set("n", "<LocalLeader>xf", "<cmd>source %<CR>", { desc = "Lua: Run File", silent = true })
vim.keymap.set("n", "<LocalLeader>xx", ":.lua<CR>", { desc = "Lua: Run Current Line", silent = true })
vim.keymap.set("v", "<LocalLeader>xx", ":lua<CR>", { desc = "Lua: Run Visual Selection", silent = true })

-- Terminal
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { desc = "Escape to Normal mode inside Terminal", silent = true })

-- Plugin Configuration
-- Setup Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup("plugins")

require("config.diagnostic")
require("config.lsp")
require("config.quickfix")

-- Setup the colorscheme
-- TODO(alvaro): Dynamic colorscheme

vim.o.background = "light"
vim.cmd([[ colorscheme solarized ]])

-- vim.o.background = "dark"
-- vim.cmd [[ colorscheme tokyonight ]]
