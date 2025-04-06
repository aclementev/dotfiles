-- List of directories that we want to always ignore even if asking for more
DIRS_TO_IGNORE = {
  ".git",
  "node_modules",
  ".mypy_cache",
  ".pytest_cache",
  "__pycache__",
}

local project_root = function()
  local status, root = pcall(vim.fn.system, "git rev-parse --show-toplevel")
  if status then
    return root
  end
end

-- TODO(alvaro): Take a look at the trouble target https://github.com/folke/trouble.nvim?tab=readme-ov-file#telescope
return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    version = "1.*",
    config = function() end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    config = function()
      local telescope = require "telescope"
      local builtin = require "telescope.builtin"

      -- FIXME(alvaro): When you run this once and cancel it, it leaves something
      -- in a weird state and you cannot find again... it looks like this changes
      -- cwd or something weird
      -- Generates a function that will call find appending a set of hardcoded
      -- excludes (useful when not in a git repo with a .gitignore)
      local function fd_with_excludes(excludes)
        local exclude_tbl = {}
        for _, dir in ipairs(excludes) do
          table.insert(exclude_tbl, "--exclude")
          table.insert(exclude_tbl, dir)
        end
        local find_options = {
          find_command = vim.list_extend({ "fd", "--type", "f", "--color", "never" }, exclude_tbl),
          follow = true,
          hidden = true,
        }

        -- Returns a function that maybe takes some directories to search
        return function(dirs)
          local opts = vim.deepcopy(find_options)

          if dirs then
            opts.search_dirs = dirs
          end

          return function()
            -- NOTE(alvaro): Telescope will add stuff to this table which can
            -- mess with the next calls, so we want to make sure to give it a
            -- new copy every time
            return builtin.find_files(vim.deepcopy(opts))
          end
        end
      end

      local fd_all_with_excludes = fd_with_excludes(DIRS_TO_IGNORE)

      -- Call the setup function
      telescope.setup {
        defaults = vim.tbl_extend("force", require("telescope.themes").get_ivy(), {
          path_display = {
            "truncate",
            -- "shorten",
            -- "smart",
          },
          mappings = {
            -- i = {
            --     ["<c-j>"] = "move_selection_next",
            --     ["<c-k>"] = "move_selection_previous",
            -- }
          },
        }),
        extensions = {
          ["ui-select"] = {
            -- FIXME(alvaro): Review this
            require("telescope.themes").get_dropdown {
              -- Any DropDown options
            },
          },
          file_browser = {
            theme = "dropdown",
            -- hijack_netrw = true,
            mappings = {
              i = {
                ["<C-W>"] = function()
                  vim.cmd "normal db"
                end,
              },
            },
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = { -- extend mappings
              i = {
                ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt { postfix = " --iglob " },
                ["<C-t>"] = require("telescope-live-grep-args.actions").quote_prompt { postfix = " -t" },
                -- freeze the current list and start a fuzzy search in the frozen list
                ["<C-s>"] = require("telescope-live-grep-args.actions").to_fuzzy_refine,
              },
            },
          },
        },
      }

      -- Register the extension modules
      telescope.load_extension "fzf"
      -- telescope.load_extension "fzy_native"
      telescope.load_extension "ui-select"
      telescope.load_extension "file_browser"
      telescope.load_extension "dap"
      telescope.load_extension "frecency"
      telescope.load_extension "live_grep_args"

      -- Configure the mappings
      local opts = { silent = true }
      vim.keymap.set("n", "<Leader>ff", function()
        return builtin.git_files { show_untracked = false, debounce = 100 }
      end, opts)
      -- TODO(alvaro): Make this mapping default to `find` if `fd` is not installed
      vim.keymap.set("n", "<Leader>fa", fd_all_with_excludes(), opts)
      vim.keymap.set("n", "<Leader>fA", function()
        return builtin.find_files {
          find_command = { "fd", "--type", "f", "--color", "never", "--exclude", ".git" },
          follow = true,
          hidden = true,
          no_ignore = true,
        }
      end, opts)
      vim.keymap.set("n", "<Leader>fd", function()
        local current_dir = vim.fn.expand "%:p:h"
        if current_dir == "" then
          current_dir = vim.loop.cwd() or vim.fn.expand "~"
        end
        vim.ui.input({ prompt = "Directory: ", default = current_dir, completion = "dir" }, function(dir)
          if dir then
            return builtin.find_files { cwd = dir }
          end
        end)
      end, opts)
      vim.keymap.set("n", "<Leader>fD", function()
        vim.ui.input({ prompt = "Directory: ", default = vim.fn.expand "~", completion = "dir" }, function(dir)
          if dir then
            return builtin.find_files { cwd = dir }
          end
        end)
      end, opts)
      vim.keymap.set("n", "<Leader>fb", builtin.buffers, opts)
      vim.keymap.set("n", "<Leader>fh", builtin.help_tags, opts)
      vim.keymap.set("n", "<Leader>fo", builtin.oldfiles, opts)
      vim.keymap.set("n", "<Leader>fl", "<cmd>Telescope frecency workspace=CWD<CR>", opts)
      vim.keymap.set("n", "<Leader>fL", "<cmd>Telescope frecency<CR>", opts)
      vim.keymap.set("n", "<Leader>fC", builtin.commands, opts)
      vim.keymap.set("n", "<Leader>fk", builtin.keymaps, opts)
      vim.keymap.set("n", "<Leader>fz", builtin.current_buffer_fuzzy_find, opts)
      vim.keymap.set("n", "<Leader>fn", fd_all_with_excludes { vim.fn.stdpath "config" }, opts)
      vim.keymap.set("n", "<Leader>fc", fd_all_with_excludes { vim.fs.joinpath(vim.fn.expand "~", "/dotfiles") }, opts)
      -- Telescope + LSP
      vim.keymap.set("n", "<Leader>fs", builtin.lsp_document_symbols, opts)
      vim.keymap.set("n", "<Leader>fw", builtin.lsp_workspace_symbols, opts)
      vim.keymap.set("n", "<Leader>fr", builtin.lsp_references, opts)
      vim.keymap.set("n", "<Leader>fe", function()
        return builtin.diagnostics { bufnr = 0 }
      end, opts)
      vim.keymap.set("n", "<Leader>fE", builtin.diagnostics, opts)
      -- Telescope + Grep
      vim.keymap.set("n", "<Leader>rg", builtin.grep_string, opts)
      vim.keymap.set("n", "<Leader>rf", function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end, opts)
      -- vim.keymap.set("n", "<Leader>rf", function()
      --   require("alvaro.telescope.custom").live_multigrep { debounce = 100, max_results = 150 }
      -- end, opts)
      vim.keymap.set("n", "<Leader>rr", function()
        builtin.live_grep { debounce = 100, max_results = 150 }
      end, opts)
      vim.keymap.set("n", "<Leader>ra", function()
        -- Get the "root" of the project, whatever it may be
        local root = project_root()
        if not root then
          return
        end
        builtin.live_grep {
          cwd = root,
        }
      end, opts)
      vim.keymap.set("n", "<Leader>rR", function()
        builtin.live_grep { debounce = 100, max_results = 150, additional_args = { "--hidden" } }
      end, opts)
      vim.keymap.set("n", "<Leader>rc", function()
        builtin.live_grep {
          search_dirs = { vim.fn.stdpath "config" },
          debounce = 100,
          max_results = 150,
          additional_args = { "--hidden" },
        }
      end, opts)
      vim.keymap.set("n", "<Leader>ri", function()
        local query = vim.fn.input "Grep > "
        if query == "" then
          return
        end
        return builtin.grep_string { search = query }
      end, opts)
      vim.keymap.set("n", "<Leader>rd", function()
        local current_dir = vim.fn.expand "%:p:h"
        if current_dir == "" then
          current_dir = vim.loop.cwd() or vim.fn.expand "~"
        end
        vim.ui.input({ prompt = "Directory: ", default = current_dir, completion = "dir" }, function(dir)
          if dir then
            return builtin.live_grep { search_dirs = { dir } }
          end
        end)
      end, opts)
      vim.keymap.set("n", "<Leader>rD", function()
        vim.ui.input({ prompt = "Directory: ", default = vim.fn.expand "~", completion = "dir" }, function(dir)
          if dir then
            return builtin.live_grep { search_dirs = { dir } }
          end
        end)
      end, opts)

      -- Setup Telescope File Browser
      vim.keymap.set("n", "<Leader>ft", function()
        telescope.extensions.file_browser.file_browser {
          -- path = "%:p:h",  -- Open withing the curren buffer
          -- respect_gitignore = false,
          hidden = true,
          grouped = true,
          previewer = false,
          initial_mode = "normal",
          layout_config = {
            height = 40,
          },
        }
      end, opts)
    end,
  },
}
