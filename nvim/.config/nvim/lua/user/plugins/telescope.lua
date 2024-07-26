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
  -- "nvim-telescope/telescope-fzy-native.nvim",
  "nvim-telescope/telescope-ui-select.nvim",
  "nvim-telescope/telescope-file-browser.nvim",
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
  },
  "nvim-telescope/telescope-dap.nvim",
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
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
        defaults = {
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
        },
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
          }
        },
      }

      -- Register the extension modules
      telescope.load_extension "fzf"
      -- telescope.load_extension "fzy_native"
      telescope.load_extension "ui-select"
      telescope.load_extension "file_browser"
      telescope.load_extension "dap"

      -- Configure the mappings
      local opts = { silent = true }
      vim.keymap.set("n", "<Leader>ff", function()
        return builtin.git_files { show_untracked = false }
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
      vim.keymap.set("n", "<Leader>fF", function()
        vim.ui.input({ prompt = "Directory: ", default = "~" }, function(dir)
          return builtin.find_files { cwd = dir }
        end)
      end, opts)
      vim.keymap.set("n", "<Leader>fb", builtin.buffers, opts)
      vim.keymap.set("n", "<Leader>fh", builtin.help_tags, opts)
      vim.keymap.set("n", "<Leader>fo", builtin.oldfiles, opts)
      vim.keymap.set("n", "<Leader>fC", builtin.commands, opts)
      vim.keymap.set("n", "<Leader>fz", builtin.current_buffer_fuzzy_find, opts)
      vim.keymap.set("n", "<Leader>fn", fd_all_with_excludes { "~/.config/nvim" }, opts)
      vim.keymap.set("n", "<Leader>fc", fd_all_with_excludes { "~/dotfiles" }, opts)
      -- Telescope + LSP
      vim.keymap.set("n", "<Leader>fs", builtin.lsp_document_symbols, opts)
      vim.keymap.set("n", "<Leader>fS", builtin.lsp_workspace_symbols, opts)
      vim.keymap.set("n", "<Leader>fr", builtin.lsp_references, opts)
      vim.keymap.set("n", "<Leader>fd", function()
        return builtin.diagnostics { bufnr = 0 }
      end, opts)
      vim.keymap.set("n", "<Leader>fD", builtin.diagnostics, opts)
      -- Telescope + Grep
      vim.keymap.set("n", "<Leader>rg", builtin.grep_string, opts)
      vim.keymap.set("n", "<Leader>rr", builtin.live_grep, opts)
      vim.keymap.set("n", "<Leader>ra", function()
        -- Get the "root" of the project, whatever it may be
        local root = project_root()
        if not root then
          return
        end
        builtin.live_grep({
          cwd = root
        })
      end, opts)
      vim.keymap.set("n", "<Leader>rw", function()
        local query = vim.fn.input("Grep > ")
        return builtin.grep_string(
          { search = query }
        )
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
