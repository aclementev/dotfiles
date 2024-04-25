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
  bufmap("n", "gW", vim.lsp.buf.workspace_symbol)
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
  bufmap("n", "K", "<cmd>Lspsaga hover_doc<CR>")
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
  { "neovim/nvim-lspconfig", dependencies = { "folke/neodev.nvim" } },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      lightbulb = {
        enable = false,
      },
    },
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
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvimdev/lspsaga.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lspconfig = require "lspconfig"
      local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Prepare the callback for when a server is attached
      local group = vim.api.nvim_create_augroup("lsp_attach", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        desc = "Running LSP related actions",
        callback = on_lsp_attach,
      })

      -- NOTE(alvaro): `pylsp` is weird and it prefers to be installed
      -- locally on every virtualenv that uses it
      -- Therefore we don't manage it through mason
      -- To install the python lsp server and all the required
      -- plugins, you can use the following command
      -- `pip install flake8 black isort mypy 'python-lsp-server[all]' python-lsp-black python-lsp-isort pylsp-mypy`
      lspconfig.pylsp.setup {
        capabilities = lsp_capabilities,
        flags = {
          debounce_text_changes = 150,
        },
        settings = {
          pylsp = {
            configurationSources = { "flake8" },
            plugins = {
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
        },
      }

      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "vimls" },
        handlers = {
          -- Default handler for every server
          function(server)
            -- See :help lspconfig-setup
            lspconfig[server].setup {
              capabilities = lsp_capabilities,
            }
          end,
          -- Server specific overrides
          ["vimls"] = function()
            lspconfig.vimls.setup {
              capabilities = lsp_capabilities,
              flags = {
                debounce_text_changes = 150,
              },
            }
          end,
          ["lua_ls"] = function()
            -- FIXME(alvaro): Review this configuration and take a look at the replacement for nvim development
            lspconfig.lua_ls.setup {
              capabilities = lsp_capabilities,
              flags = {
                debounce_text_changes = 150,
              },
              settings = {
                Lua = {
                  -- Do not send telemetry data containing a randomized but unique identifier
                  telemetry = {
                    enable = false,
                  },
                },
              },
            }
          end,
          ["pylsp"] = function()
            -- NOTE(alvaro): `pylsp` is weird and it prefers to be installed
            -- locally on every virtualenv that uses it
            -- Therefore we don't manage it through mason
            -- This does nothing on purpose
          end,
          ["rust_analyzer"] = function()
            -- We are using the plugin https://github.com/mrcjkb/rustaceanvim
            -- which takes care of configuring the LSP, so we don't
            -- do it. This explicitly does not call lspconfig["rust-analyzer"].setup()
            -- The rest is taken care of in the plugin configuration
          end,
        },
      }
    end,
  },
  -- LSP Progress notifications
  "j-hui/fidget.nvim",
}
