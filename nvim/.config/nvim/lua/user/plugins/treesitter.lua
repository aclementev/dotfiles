local install_languages = {
  "bash",
  "clojure",
  "comment",
  "css",
  "dockerfile",
  "elixir",
  "gitcommit",
  "gitignore",
  "go",
  "html",
  "htmldjango",
  "javascript",
  "json",
  -- "just",  -- For now this seems like it does not install, but it's technically supported
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "rust",
  "terraform",
  "toml",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
}

return {
  "nvim-treesitter/playground",
  "nvim-treesitter/nvim-treesitter-textobjects",
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      max_lines = 5,
      min_window_height = 20,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup {
        ensure_installed = install_languages,
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          -- NOTE(alvaro): This can be set to a list of languages
          -- Enable :h syntax to run alongside treesitter.
          -- This is useful if you rely on the builtin syntax for things like
          -- indentation, but can result in duplicated highlights and weird
          -- behavior
          additional_vim_regex_highlighting = false,
        },
        indent = {
          -- NOTE: This is still experimental
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn", -- set to `false` to disable one of the mappings
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        -- nvim-treesiter/playground config
        playground = {
          enable = true,
        },
        -- nvim-treesiter/nvim-treesitter-textobjects config
        textobjects = {
          select = {
            enable = true,
            -- You can use capture groups defined in textobjects.scm
            keymaps = {
              ["if"] = "@function.inner",
              ["af"] = "@function.outer",
              ["ic"] = "@class.inner",
              ["ac"] = "@class.outer",
              ["ia"] = "@parameter.inner",
              ["aa"] = "@parameter.outer",
              ["ib"] = "@block.inner",
              ["ab"] = "@block.outer",
            },
            include_surrounding_whitespace = true,
          },
          swap = {
            enable = true,
            swap_next = {
              ["<Leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<Leader>A"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[["] = "@class.outer",
            },
          },
        },
      }
    end,
  },
}
