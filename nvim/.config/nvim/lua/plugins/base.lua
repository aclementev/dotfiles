-- Plugins that are generally useful, or core dependencies of others
return {
  -- Core dependency for many plugins
  { "nvim-lua/plenary.nvim" },

  -- tpope essentials
  "tpope/vim-surround", -- Text objects for surrounding
  "tpope/vim-repeat", -- Allow for repeating (some) plugin commands
  "tpope/vim-sleuth", -- Detect shiftwidth, tabstop from the current file
  "tpope/vim-scriptease", -- Tools for debugging vim plugins

  -- DB UI
  "tpope/vim-dadbod",
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod", "kristijanhusak/vim-dadbod-completion" },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function() vim.g.db_ui_use_nerd_fonts = 1 end,
  },

  -- Extra text-objects
  { "echasnovski/mini.ai", version = "*" },
}
