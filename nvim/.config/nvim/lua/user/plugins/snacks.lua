return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      input = {
        enabled = true,
      },
      bigfile = {
        notify = true,
        size = 1.5 * 1024 * 1024, -- 1.5MB
        line_length = 1000,
      },
      dashboard = {
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
      notifier = {
        enabled = true,
      },
    },
    keys = {
      {
        "<Leader>dd",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss notifications",
      },
      {
        "<Leader>dt",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Navigate notification history",
      },
    },
  },
}
