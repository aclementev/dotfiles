-- Define a :Browse command so that fugitive knows how to open a url without Netrw
vim.api.nvim_create_user_command(
  "Browse",
  function(opts)
    local url = opts.args
    vim.ui.open(url)
  end,
  { nargs = 1 }
)

local main_branch_name = os.getenv("GIT_BASE_BRANCH") or "main"

return {
  "tpope/vim-rhubarb",
  {
    lazy = false,
    "tpope/vim-fugitive",
    keys = {
      {
        "<LocalLeader>G",
        "<cmd>Git<CR>",
        desc = "Fugitive: Git status",
      },
      {
        "<LocalLeader>gb",
        "<cmd>Git blame<CR>",
        desc = "Fugitive: Git blame",
      },
      {
        "<LocalLeader>gg",
        "<cmd>GBrowse<CR>",
        desc = "Fugitive: Git browse",
      },
      {
        "<LocalLeader>gm",
        string.format("<cmd>GBrowse %s:%%<CR>", main_branch_name),
        desc = "Fugitive: Git browse main",
      },
      {
        "<LocalLeader>gg",
        -- NOTE(alvaro): I could not figure out how to handle properly the visual range using <cmd>
        ":<C-U>'<,'>GBrowse<CR>",
        desc = "Fugitive: Git browse (visual range)",
        mode = "v"
      },
      {
        "<LocalLeader>gm",
        desc = "Fugitive: Git browse (visual range)",
        string.format(":<C-U>'<,'>GBrowse %s:%%<CR>", main_branch_name),
        mode = "v"
      },
    }
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
      numhl = true,
    },
    keys = {
      {
        "<LocalLeader>gs",
        function()
          require("gitsigns").stage_hunk()
        end,
        desc = "Git: Stage Hunk",
      },
      {
        "<LocalLeader>gr",
        function()
          require("gitsigns").reset_hunk()
        end,
        desc = "Git: Restore Hunk",
      },
      {
        "]c",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            require("gitsigns").nav_hunk("next")
          end
        end,
        desc = "Git: Navigate to next hunk",

      },
      {
        "]c",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            require("gitsigns").nav_hunk("prev")
          end
        end,
        desc = "Git: Navigate to prev hunk",

      },
      {
        "<LocalLeader>gs",
        function()
          require("gitsigns").stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end,
        mode = "v",
        desc = "Git: Stage visual selection",
      },
      {
        "<LocalLeader>gr",
        function()
          require("gitsigns").reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end,
        mode = "v",
        desc = "Git: Restore visual selection",
      },
      {
        "<LocalLeader>gS",
        function()
          require("gitsigns").stage_buffer()
        end,
        desc = "Git: Stage Buffer",
      },
      {
        "<LocalLeader>gR",
        function()
          require("gitsigns").reset_buffer()
        end,
        desc = "Git: Restore Buffer",
      },
      {
        "<LocalLeader>gu",
        function()
          require("gitsigns").undo_stage_hunk()
        end,
        desc = "Git: Undo stage hunk",
      },
      {
        "<LocalLeader>gP",
        function()
          require("gitsigns").preview_hunk()
        end,
        desc = "Git: Preview Hunk",
      },
      {
        "<LocalLeader>gl",
        function()
          require("gitsigns").blame_line { full = true }
        end,
        desc = "Git: Blame Line",
      },
      {
        "<LocalLeader>tb",
        function()
          require("gitsigns").toggle_current_line_blame()
        end,
        desc = ":Git: Toggle Current Line Blame",
      },
      {
        "<LocalLeader>gd",
        function()
          require("gitsigns").diffthis()
        end,
        desc = "Git: Diff current file against index",
      },
      {
        "<LocalLeader>gD",
        function()
          require("gitsigns").diffthis "~1"
        end,
        desc = "Git: Diff current file against previous commit",
      },
      {
        "<LocalLeader>td",
        function()
          require("gitsigns").toggle_deleted()
        end,
        desc = "Git: Toggle Deleted (?)",
      },
      -- Text Object
      { "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Git: Hunk text object" },
    },
  },
}
