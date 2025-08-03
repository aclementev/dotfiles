---@brief
---
--- https://github.com/python-lsp/python-lsp-server
---
--- A Python 3.6+ implementation of the Language Server Protocol.
---
--- See the [project's README](https://github.com/python-lsp/python-lsp-server) for installation instructions.
---
--- Configuration options are documented [here](https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md).
--- In order to configure an option, it must be translated to a nested Lua table and included in the `settings` argument to the `config('pylsp', {})` function.
--- For example, in order to set the `pylsp.plugins.pycodestyle.ignore` option:
--- ```lua
--- vim.lsp.config('pylsp', {
---   settings = {
---     pylsp = {
---       plugins = {
---         pycodestyle = {
---           ignore = {'W391'},
---           maxLineLength = 100
---         }
---       }
---     }
---   }
--- })
--- ```
---
--- Note: This is a community fork of `pyls`.
return {
  cmd = { "pylsp" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
  -- NOTE(alvaro): Custom options
  settings = {
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
}
