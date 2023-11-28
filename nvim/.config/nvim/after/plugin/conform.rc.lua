local status, conform = pcall(require, "conform")
if not status then
	return
end

conform.setup{
    formatters_by_ft = {
        go = { "goimports", "gofmt" },
        html = { { "prettierd", "prettier" } },
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
}

-- Set this value to true to silence errors when formatting a block fails
require("conform.formatters.injected").options.ignore_errors = false

local opts = { silent = true, buffer = 0 }

-- Keybinds
vim.keymap.set("n", "<LocalLeader>f", function()
    conform.format({ async = true, lsp_fallback = true })
end, opts)
vim.keymap.set("x", "<LocalLeader>f", function()
    conform.format({ async = true, lsp_fallback = true })
end, opts)
