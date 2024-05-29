local function on_lsp_attach(ev)
  local bufmap = function(mode, lhs, rhs)
    local opts = { buffer = ev.buf, silent = true }
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- Enable omnifunc completion (triggered by <C-X><C-O>)
  vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

  bufmap("n", "gd", vim.lsp.buf.definition)
  bufmap("n", "gD", vim.lsp.buf.declaration)
  -- bufmap('n', 'K', vim.lsp.buf.hover)
  bufmap("n", "gi", vim.lsp.buf.implementation)
  bufmap("n", "gI", vim.lsp.buf.type_definition)
  bufmap("n", "gk", vim.lsp.buf.signature_help)
  bufmap("n", "gr", vim.lsp.buf.references)
  bufmap("n", "g0", vim.lsp.buf.document_symbol)
  bufmap("n", "gw", function()
    local cword = vim.fn.expand "<cword>"
    vim.lsp.buf.workspace_symbol(cword)
  end)
  bufmap("n", "gW", vim.lsp.buf.workspace_symbol)
  bufmap("n", "gh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end)
  bufmap("i", "<C-H>", vim.lsp.buf.signature_help)
  bufmap("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder)
  bufmap("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder)
  bufmap("n", "<Leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)
  -- NOTE(alvaro): Formatting is configured in its own file

  -- LspSaga related commands
  bufmap("n", "<LocalLeader>ca", "<cmd>Lspsaga code_action<CR>")
  bufmap("v", "<LocalLeader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>")
  -- bufmap("n", "K", "<cmd>Lspsaga hover_doc<CR>")
  -- FIXME(alvaro): update these mappings, although they may just work
  bufmap("n", "<C-f>", function()
    require("lspsaga.action").smart_scroll_with_saga(4)
  end)
  bufmap("n", "<C-b>", function()
    require("lspsaga.action").smart_scroll_with_saga(-4)
  end)
  bufmap("n", "<LocalLeader>rn", "<cmd>Lspsaga rename<CR>")
  bufmap("n", "<LocalLeader>rN", "<cmd>Lspsaga rename ++project<CR>")
  bufmap("n", "gp", "<cmd>Lspsaga preview_definition<CR>")

  -- Others
  -- TODO(alvaro): Do this all in a custom command in lua, now is a bit flickery
  bufmap("n", "gs", ":vsp<CR><cmd>lua vim.lsp.buf.definition()<CR>zz")
  bufmap("n", "gx", ":sp<CR><cmd>lua vim.lsp.buf.definition()<CR>zz")
end

return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      log_level = vim.log.levels.INFO,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neodev.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "nvimdev/lspsaga.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = nil
      if pcall "cmp_nvim_lsp" then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      local lspconfig = require "lspconfig"

      local common_settings = {
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150, -- We want some debouncing
        },
      }

      -- There are some servers that we want to manage using Mason, which handles
      -- installing them and updating them and others that we want to manage
      -- using lspconfig direclty

      local servers = {
        pylsp = {
          settings = {
            flake8 = {
              enabled = true,
            },
            -- pip install python-lsp-black
            black = {
              enabled = true,
            },
            -- pip install python-lsp-isort
            isort = {
              enabled = true,
            },
            -- pip install pylsp-mypy
            pylsp_mypy = {
              enabled = true,
              live_mode = false, -- This does not work with dmypy enabled currently
              -- TODO(alvaro): Try this again
              dmypy = true,
              report_progress = true,
            },
            -- TODO(alvaro): Try these
            rope_autoimport = {
              enabled = false,
              completions = {
                enabled = true,
              },
              code_actions = {
                enabled = true,
              },
            },
            -- Disable these plugins explicitly
            yapf = {
              enabled = false,
            },
            pycodestyle = {
              enabled = false,
            },
            pylint = {
              enabled = false,
            },
            mccabe = {
              enabled = false,
            },
            autopep8 = {
              enabled = false,
            },
            pydocstyle = {
              enabled = false,
            },
            pyflakes = {
              enabled = false,
            },
          },
        },
        lua_ls = true,
        vimls = true,
        gopls = true,
        rust_analyzer = true,
      }

      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "vimls" },
      }

      -- Setup all the configured servers
      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end

        config = vim.tbl_deep_extend("force", {}, common_settings, config)

        lspconfig[name].setup(config)
      end

      -- Prepare the callback for when a server is attached
      local group = vim.api.nvim_create_augroup("lsp_attach", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        desc = "Running LSP related actions",
        callback = on_lsp_attach,
      })
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      lightbulb = {
        enable = false,
      },
    },
  },
  -- LSP Progress notifications
  "j-hui/fidget.nvim",
}
