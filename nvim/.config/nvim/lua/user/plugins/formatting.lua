-- List of languages for which we want format on save
local LANGUAGES_ON_SAVE = { "go" }

-- TODO(alvaro): See this recipe https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#lazy-loading-with-lazynvim
return {
  {
    "stevearc/conform.nvim",
    config = function()
      local conform = require "conform"
      conform.setup {
        timeout_ms = 1000,
        format_on_save = function(bufnr)
          -- Get the filetype of the language 
          if vim.tbl_contains(LANGUAGES_ON_SAVE, vim.bo[bufnr].filetype) then
            return {
              timeout_ms = 500,
              lsp_fallback = true,
            }
          end
        end,
        formatters_by_ft = {
          go = { "goimports", "gofmt" },
          html = { "prettierd", "prettier", stop_after_first = true },
          htmldjango = { "prettierd", "prettier", stop_after_first = true },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          justfile = { "just" },
          lua = { "stylua" },
          ocaml = { "ocamlformat" },
          -- TODO(alvaro): enable ruff if it's available and configured
          python = function(bufnr)
            if conform.get_formatter_info("ruff_format", bufnr).available then
              return { "ruff_organize_imports", "ruff_format" }
            else
              return { "isort", "black" }
            end
          end,
          rust = { "rustfmt" },
          sql = { "sqlfluff" },
          terraform = { "terraform_fmt" },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          vue = { "prettierd", "prettier", stop_after_first = true },
        },
        notify_on_error = true,
      }
    end,
    keys = {
      {
        "<LocalLeader>f",
        function()
          require("conform").format { async = true, lsp_fallback = true }
        end,
        mode = "n",
        desc = "Run the formatter on the whole file",
      },
      {
        "<LocalLeader>f",
        function()
          require("conform").format { async = true, lsp_fallback = true }
        end,
        mode = "x",
        desc = "Run the formatter on the selected range",
      },
    },
  },
}
