local LANGUAGES_ON_SAVE = { "go" }

-- TODO(alvaro): See this recipe https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#lazy-loading-with-lazynvim
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    opts = {
      timeout_ms = 1000,
      format_on_save = function(bufnr)
        -- Get the filetype of the language
        if vim.tbl_contains(LANGUAGES_ON_SAVE, vim.bo[bufnr].filetype) then
          return {
            timeout_ms = 500,
            lsp_format = "fallback",
          }
        end
      end,
      formatters_by_ft = {
        go = { "gofmt", "goimports" },
        html = { "prettierd", "prettier", stop_after_first = true },
        htmldjango = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        justfile = { "just" },
        lua = { "stylua" },
        ocaml = { "ocamlformat" },
        python = { "ruff_format", "ruff_organize_imports" },
        rust = { "rustfmt" },
        sql = { "sqlfluff" },
        terraform = { "terraform_fmt" },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        vue = { "prettierd", "prettier", stop_after_first = true },
      },
      notify_on_error = true,
    },
    keys = {
      {
        "<LocalLeader>f",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        mode = { "n", "x" },
        desc = "Run the formatter on the whole file",
      },
    },
  },
}
