-- TODO(alvaro): See this recipe https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#lazy-loading-with-lazynvim
return {
  {
    "stevearc/conform.nvim",
    opts = {
      timeout_ms = 1000,
      formatters_by_ft = {
        go = { "goimports", "gofmt" },
        html = { { "prettierd", "prettier" } },
        htmldjango = { { "prettierd", "prettier" } },
        javascript = { { "prettierd", "prettier" } },
        justfile = { "just" },
        lua = { "stylua" },
        ocaml = { "ocamlformat" },
        -- TODO(alvaro): enable ruff if it's available and configured
        -- python = function(bufnr)
        --     if conform.get_formatter_info("ruff_format", bufnr).available then
        --         return { "ruff_format" }
        --     else
        --         return { "isort", "black" }
        --     end
        -- end,
        python = { "isort", "black" },
        rust = { "rustfmt" },
        sql = { "sqlfluff" },
        terraform = { "terraform_fmt" },
        typescript = { { "prettierd", "prettier" } },
        vue = { { "prettierd", "prettier" } },
      },
      notify_on_error = true,
    },
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
