return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "default",
        ["<C-n>"] = { "show_and_insert", "select_next" },
        ["<C-p>"] = { "show_and_insert", "select_prev" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        ghost_text = {
          enabled = false,
        },
        menu = {
          auto_show = false,
          border = "rounded",
        },
        documentation = {
          auto_show = true,
          window = {
            border = "rounded",
          },
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        -- per_filetype = { sql = { "dadbod" } },
        providers = {
          path = {
            opts = {
              get_cwd = function() return vim.fn.getcwd() end,
            },
          },
          -- dadbod = { module = "vim_dadbod_completion.blink" },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
