-- Load the common configuration
pcall(vim.cmd.source, "~/.vimrc")

-- General Options
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes:1" -- Merge the signcolumn and number column
vim.opt.mouse = "a" -- Setup the mouse
vim.opt.scrolloff = 10 -- Space when scrolling UP and DOWN
vim.opt.mousemoveevent = true

-- Add an explicit python3 provider to avoid slow
vim.g.python3_host_prog = vim.fn.expand "~/.pyenv/versions/3.12.3/bin/python"

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

-- FIXME(alvaro): Review the colorscheme setup now that we have Lazy with priority and whatnot
-- Setup the plugins
-- FIXME(alvaro): Review which of these are used directly and which can be declared as dependency
require("lazy").setup({
  -- The base depenencies
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",

  -- Colorschemes
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  -- NOTE(alvaro): This is un-maintained, we should look into a fork (e.g: Shatur/neovim-ayu or Luxed/ayu-vim)
  { "Luxed/ayu-vim", lazy = false, priority = 1000 },
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
  "norcalli/nvim-colorizer.lua",
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("alpha").setup(require("alpha.themes.theta").config)
    end,
  },
  {
    "rcarriga/nvim-notify",
    lazy = false,
    -- Start before the rest of the plugins
    priority = 100,
    config = function()
      local notify = require "notify"
      ---@diagnostic disable-next-line: missing-fields
      notify.setup {
        -- See render styles in documentation
        render = "compact",
        stages = "fade_in_slide_out",
        timeout = 5000,
        top_down = true,
      }
      -- Set notify as the default notification handler for vim
      vim.notify = notify
    end,
    keys = {
      {
        "<Leader>dd",
        function()
          require("notify").dismiss()
        end,
        desc = "Dismissis notifications"
      },
    },
  },

  -- Lua Neovim development
  {
    "folke/neodev.nvim",
    opts = {
      override = function(root_dir, library)
        -- TODO(alvaro): We should make this more portable... but for now this
        -- works
        if string.find(root_dir, "dotfiles/nvim/.config/nvim") then
          library.enabled = true
          library.plugins = true
        end
      end,
    },
  },

  -- AI Assistant
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

  -- DB Access
  "tpope/vim-dadbod",
  {
    "kristijanhusak/vim-dadbod-ui",
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  -- Language specific
  "guns/vim-sexp",
  "tpope/vim-sexp-mappings-for-regular-people",
  -- "jpalardy/vim-slime",
  {
    "Olical/conjure",
    init = function()
      vim.g["conjure#filetypes"] = { "clojure", "fennel", "janet", "hy", "racket", "scheme", "lisp" }
      vim.g["conjure#filetype#julia"] = false
      vim.g["conjure#filetype#lua"] = false
      vim.g["conjure#filetype#python"] = false
      vim.g["conjure#filetype#rust"] = false
      vim.g["conjure#filetype#sql"] = false
    end,
  },
  "clojure-vim/vim-jack-in",
  "tpope/vim-dispatch",
  "radenling/vim-dispatch-neovim",

  { import = "user.plugins" },
}, {
  defaults = {
    version = "*", -- Install the latest stable version (following Semver rules)
  },
})

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

-- Set the colorscheme
require "alvaro.colorscheme"

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

-- Load the basic configuration
require "alvaro"

-- FIXME(alvaro): Move this to utilities or formatting file
---@diagnostic disable-next-line: unused-local, unused-function
local function trim_whitespace()
  -- Store the current position of the cursor
  local pos = vim.fn.getpos "."
  -- Trim the trailing whitespace from the whole document
  -- NOTE: This may move the cursor
  vim.cmd [[ silent g/\s\+$/s/\s*$// ]]
  -- Restore the position before the trimming
  vim.fn.setpos(".", pos)
end

-- TODO(alvaro): Maybe enable this back?
-- Setup automatic space trimming on some files
-- autocmd FileType c,cpp,java,javascript,typescript,python,lua,vim autocmd BufWritePre <buffer> call TrimWhitespace()

-- Complex custom mappings
-- vim.keymap.set("n", "<LocalLeader>gg", ":<C-U>GithubOpen<CR>", { silent = true })
-- vim.keymap.set("n", "<LocalLeader>gG", ":<C-U>GithubOpenCurrent<CR>", { silent = true })
-- vim.keymap.set("n", "<LocalLeader>gg", ":GithubOpen<CR>", { silent = true })
-- vim.keymap.set("n", "<LocalLeader>gG", ":GithubOpenCurrent<CR>", { silent = true })

vim.api.nvim_create_user_command("JSONFormat", ":%! jq .", { desc = "Prettify JSON using jq" })
vim.api.nvim_create_user_command("JSONCompact", ":%! jq -c .", { desc = "Compact JSON using jq" })

-- Add custom filetype mappings
vim.filetype.add { extension = { tf = "terraform" } }
