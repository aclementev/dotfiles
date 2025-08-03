-- Load the common configuration
local status, _ = pcall(vim.cmd.source, "~/.vimrc")
if not status then
  vim.notify("Failed to base vim settings", vim.log.levels.ERROR)
end

-- General Options
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes:1" -- Merge the signcolumn and number column
vim.opt.mouse = "a" -- Setup the mouse
vim.opt.scrolloff = 10 -- Space when scrolling UP and DOWN
vim.opt.mousemoveevent = true
vim.opt.exrc = true

-- FIXME(avlaro): This makes unstlyed windows look better, but breaks styling for other ones like `Telescope`'s
-- Try with a more modern version of Telescope
-- FIXME(alvaro): This is currently not supported in many plugins (plenary based like Telescope, notify, etc)
-- vim.opt.winborder = "rounded" -- Floating window styling

-- Load the basic configuration
require "alvaro"

-- Lazy.nvim setup
-- Install Lazy (if necessary)
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Prepare a callback for when all the plugins are configured
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = function()
    -- Setup the LSP
    require("alvaro.lsp").setup()

    -- Set the colorscheme
    require "alvaro.colorscheme"
  end,
})

-- FIXME(alvaro): Review the colorscheme setup now that we have Lazy with priority and whatnot
-- Setup the plugins
-- FIXME(alvaro): Review which of these are used directly and which can be declared as dependency
require("lazy").setup({
  -- The base depenencies
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",

  -- Colorschemes
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      dim_inactive = true,
    },
  },
  -- We use this as the light colorscheme
  { "ericbn/vim-solarized", lazy = false, priority = 1000 },

  -- Some of tpope's must have plugins (all hail the almighty tpope)
  "tpope/vim-surround", -- Text objects for surrounding
  -- "tpope/vim-commentary", -- Simple mapping for commenting
  "tpope/vim-repeat", -- Allow for repeating (some) plugin commands
  "tpope/vim-sleuth", -- Detect shiftwidth, tabstop from the current file
  "tpope/vim-scriptease", -- Tools for debugging vim plugins

  -- TODO(alvaro): Look into this
  -- 'romainl/vim-qf'

  -- Eye candy
  "junegunn/vim-easy-align",
  { "nvim-tree/nvim-web-devicons", lazy = false, priority = 2000, opts = { default = true } },
  { "norcalli/nvim-colorizer.lua", opts = {} },
  {
    "echasnovski/mini.indentscope",
    version = "*",
    opts = {
      symbol = "│",
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      cursor_color = "none",
      vertical_bar_cursor_insert_mode = true,
    },
  },
  -- Lua Neovim development
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Also enable the neovim APIs inside any installed plugins
        "~/.local/share/nvim/lazy",
        -- Load the luvit types if we find a reference to `vim.uv`
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  -- AI Assistant
  -- TODO(alvaro): Checkout avante.nvim
  -- {
  --   "github/copilot.vim",
  --   lazy = false,
  --   init = function()
  --     -- Make sure that <Tab> is not mapped automatically
  --     -- vim.g.copilot_no_tab_map = true
  --   end,
  --   keys = {
  --     { "<C-L>", 'copilot#Accept("")', mode = "i", silent = true, expr = true, replace_keycodes = false },
  --   },
  -- },
  { "echasnovski/mini.ai", version = "*" },

  -- DB Access
  "tpope/vim-dadbod",
  {
    "kristijanhusak/vim-dadbod-ui",
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  { import = "user.plugins" },
}, {
  defaults = {
    version = "*", -- Install the latest stable version (following Semver rules)
  },
})

-- Lua keymaps
vim.keymap.set("n", "<LocalLeader>xf", "<cmd>source %<CR>", { desc = "Lua: Run File", silent = true })
vim.keymap.set("n", "<LocalLeader>xx", ":.lua<CR>", { desc = "Lua: Run Current Line", silent = true })
vim.keymap.set("v", "<LocalLeader>xx", ":lua<CR>", { desc = "Lua: Run Visual Selection", silent = true })

-- Fix the colorscheme so that the SignColumn does not have a different
-- background
-- Make sure it is applied everytime we change the colorscheme
-- NOTE: This must happen before sourcing the colorscheme, or else it's not
-- applied on first execution
local transparent_augroup = vim.api.nvim_create_augroup("transparent_signs", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  group = transparent_augroup,
  command = "highlight SignColumn guibg=NONE",
})

-- FIXME(alvaro): Review if we are using these, since we are now using `term-edit`
-- Terminal Settings
local terminal_augroup = vim.api.nvim_create_augroup("alvaro_terminal", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  group = terminal_augroup,
  command = "setlocal nonumber statusline=%{b:term_title} | startinsert",
})
vim.keymap.set("n", "<Leader>ts", ":20sp +term<CR>")
vim.keymap.set("n", "<Leader>tv", ":vsp +term<CR>")

-- Set the highlight on yank
local highlight_augroup = vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  group = highlight_augroup,
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 300 }
  end,
})

-- Print the syntax group of the element under the cursor
local function syn_group()
  local pos = vim.fn.getpos "."
  local line = pos[2]
  local col = pos[3]
  local syn_id = vim.fn.synID(line, col, 1)
  print(vim.fn.synIDattr(syn_id, "name"), "->", vim.fn.synIDattr(vim.fn.synIDtrans(syn_id), "name"))
end

vim.api.nvim_create_user_command(
  "SynGroup",
  syn_group,
  { desc = "Print the syntax group of the element under the cursor" }
)
vim.keymap.set("n", "<LocalLeader>sg", ":<C-U>SynGroup<CR>", { silent = true })

-- Formatting
local function trim_whitespace()
  -- Store the current position of the cursor
  local pos = vim.fn.getpos "."
  -- Trim the trailing whitespace from the whole document
  -- NOTE: This may move the cursor
  vim.cmd [[ silent g/\s\+$/s/\s*$// ]]
  -- Restore the position before the trimming
  vim.fn.setpos(".", pos)
  -- Clear the highlight search
  vim.cmd [[ nohlsearch ]]
end
vim.api.nvim_create_user_command("TrimWhitespace", function()
  trim_whitespace()
end, { force = true, desc = "Trim the whitespace from the end of all lines in the file" })
vim.keymap.set(
  "n",
  "<Leader>td",
  "<cmd>TrimWhitespace<CR>",
  { silent = true, desc = "Trim the whitespace from the end of all lines in the file" }
)

vim.api.nvim_create_user_command("JSONFormat", ":%! jq .", { desc = "Prettify JSON using jq" })
vim.api.nvim_create_user_command("JSONCompact", ":%! jq -c .", { desc = "Compact JSON using jq" })

-- Add custom filetype mappings
vim.filetype.add { extension = { tf = "terraform" } }

-- Other mappings
vim.keymap.set("c", "<M-b>", "<S-Left>", { noremap = true }) -- This is actually <M-Left>
vim.keymap.set("c", "<M-f>", "<S-Right>", { noremap = true }) -- This is actually <M-Ritgh>

vim.keymap.set("n", "<Leader>cp", function()
  vim.fn.setreg("+", vim.fn.expand "%")
end, { silent = true })
vim.keymap.set("n", "<Leader>cP", function()
  vim.fn.setreg("+", vim.fn.expand "%:p")
end, { silent = true })
vim.keymap.set("n", "<Leader>cf", function()
  vim.fn.setreg("+", vim.fn.expand "%:t")
end, { silent = true })

-- Comment Reflower
-- Prepare a reflow comments command with a keybind this is a very very very long comment this is another line Prepare a reflow comments command with a
-- Prepare a reflow comments command with a keybind this is a very very very long comment this is another line Prepare a reflow comments command with a
vim.api.nvim_create_user_command("ReflowComment", function(args)
  local old_formatexpr = vim.bo.formatexpr
  local old_textwidth = vim.bo.textwidth

  -- Remove the default formatexpr, which may be set to LSP formatting, so that
  -- we use vim's builtin formatting that will use textwidth
  vim.bo.formatexpr = ""
  -- FIXME(alvaro): Create a mechanism for passing another value to this
  vim.bo.textwidth = old_textwidth or 80

  -- We have to manually run `gq` on the target lines
  local n_lines
  if args.range == 0 or args.range == 1 then
    n_lines = 1
  elseif args.range == 2 then
    n_lines = args.line2 - args.line1 + 1
  end
  local cmd = string.format("%dgqq", n_lines)

  -- Call this protected so that we always reset the options back
  pcall(vim.cmd.normal, cmd)

  -- Reset the options
  vim.bo.formatexpr = old_formatexpr
  vim.bo.textwidth = old_textwidth
end, {
  range = true,
  desc = "Reformat a multiline comment making sure it does not go over the line width limit",
  force = true,
})

vim.keymap.set("n", "<LocalLeader>cf", "<cmd>ReflowComment<CR>", { desc = "Reflow selected comment" })
vim.keymap.set("x", "<LocalLeader>cf", "<cmd>ReflowComment<CR>", { desc = "Reflow selected comment" })
