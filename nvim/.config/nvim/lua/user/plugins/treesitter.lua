local install_languages = {
  "bash",
  "comment",
  "css",
  "dockerfile",
  "gitcommit",
  "gitignore",
  "go",
  "html",
  "htmldjango",
  "javascript",
  "json",
  "just",
  "kotlin",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
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
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
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
        -- nvim-treesiter/nvim-treesitter-textobjects config
        textobjects = {
          select = {
            enable = true,
            disable = {
              -- Rust treesitter queries are very slow for this
              "rust",
              -- Typescript queries throw an error
              "typescript",
            },
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
            selection_modes = {
              -- Make these selections line wise instead of characterwise
              ["@function.inner"] = "V",
              ["@function.outer"] = "V",
              ["@class.inner"] = "V",
              ["@class.outer"] = "V",
              ["@block.outer"] = "V",
            }
          },
          lsp_interop = {
            enable = true,
            border = "none",
            peek_definition_code = {
              ["<Leader>kf"] = "@function.outer",
              ["<Leader>kc"] = "@class.outer",
            },
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
  { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = { "nvim-treesiter/nvim-treesitter" } },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesiter/nvim-treesitter" },
    opts = {
      max_lines = 5,
      min_window_height = 20,
    },
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      }
    end,
  },
}
