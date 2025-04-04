return {
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
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "vimls" },
    },
  },
  -- File Operations
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neodev.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "nvimdev/lspsaga.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "antosha417/nvim-lsp-file-operations",
    },
    config = function()
      require("alvaro.lsp").setup()

      local lspconfig = require "lspconfig"

      local default_capabilities = vim.lsp.protocol.make_client_capabilities()
      local basic_capabilities = {
        textDocument = {
          semanticTokens = {
            multilineTokenSupport = true,
          },
        },
      }
      local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
      local file_capabilities = require("lsp-file-operations").default_capabilities()
      local common_capabilities =
        vim.tbl_deep_extend("force", default_capabilities, basic_capabilities, cmp_capabilities, file_capabilities)

      -- There are some servers that we want to manage using Mason, which handles
      -- installing them and updating them and others that we want to manage
      -- using lspconfig direclty

      -- FIXME(alvaro): Figure out how to move these settings to make use of the new
      -- LSP config protocol with `lsp/<name>.lua` and `nvim-lspconfig`
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
            -- pip install python-lsp-ruff
            ruff = {
              enabled = true,
              formatEnabled = true,
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

      local common_config = {
        capabilities = common_capabilities,
        flags = {
          -- FIXME(alvaro): Not sure which servers actually use this
          debounce_text_changes = 150,
        },
      }

      -- Setup all the configured servers
      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend("force", {}, common_config, config)
        lspconfig[name].setup(config)
      end
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
