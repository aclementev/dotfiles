return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function()
      require("luasnip").setup {
        -- This tells luasnip to remember the last snippet so you can
        -- jump back to it even if you move outside the selection
        history = false,
        -- TODO(alvaro): Test if this is too distracting
        -- This makes is so that dynamic snippets update as you change
        updateevents = "TextChanged,TextChangedI",
        -- TODO(alvaro): Figure out what these are
        -- Enable autosnippets (if true).
        enable_autosnippets = false,
      }

      -- Preload the local snippets that use `SnipMate` syntax (from `snippets/` directory in conf)
      require("luasnip.loaders.from_snipmate").lazy_load()
      -- Preload the VSCode like snippets from plugins (i.e: rafamadriz/friendly-snippets)
      -- require("luasnip.loaders.from_vscode").lazy_load()
      -- require("luasnip").filetype_extend("python", { "django" })
      -- require("luasnip").filetype_extend("javascript", { "vue" })
    end,
    keys = {
      {
        "<C-J>",
        function()
          local ls = require "luasnip"
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
          end
        end,
        mode = { "i", "s" },
        silent = true,
        desc = "Snippet: Expand or Jump to next slot",
      },
      {
        "<C-K>",
        function()
          local ls = require "luasnip"
          if ls.jumpable(-1) then
            ls.jump()
          end
        end,
        mode = { "i", "s" },
        silent = true,
        desc = "Snippet: Jump to previous slot",
      },
    },
  },
}
