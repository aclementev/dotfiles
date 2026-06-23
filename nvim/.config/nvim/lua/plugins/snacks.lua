-- Fuzzy-pick an immediate subdirectory under `cwd` (via fd), then run `action(abs_dir)`.
-- If the user cancels, `action` is never called.
local function pick_directory(opts, action)
  opts = opts or {}
  local cwd = opts.cwd or vim.fn.expand("%:p:h")
  if cwd == nil or cwd == "" then
    cwd = vim.uv.cwd()
  end
  local res = vim.system(
    { "fd", "--type", "d", "--color", "never", "--max-depth", "1" },
    { cwd = cwd, text = true }
  ):wait()
  local dirs = vim.split(vim.trim(res.stdout or ""), "\n", { trimempty = true })
  if #dirs == 0 then
    vim.notify("No directories found under " .. cwd, vim.log.levels.WARN)
    return
  end
  Snacks.picker.select(dirs, { prompt = "Directory to search" }, function(choice)
    if choice then
      action(vim.fs.joinpath(cwd, choice))
    end
  end)
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = {},
      -- FIXME(alvaro): bigfile breaks on .git/index (e.g. opening :Git via fugitive)
      bigfile = { enabled = false },
    },
    keys = {
      { "<Leader>ff", function() Snacks.picker.git_files() end, desc = "Find git files" },
      { "<Leader>fa", function() Snacks.picker.files() end, desc = "Find all files" },
      {
        "<Leader>fd",
        function() pick_directory({}, function(dir) Snacks.picker.files({ cwd = dir }) end) end,
        desc = "Find files in directory",
      },
      {
        "<Leader>fD",
        function() pick_directory({ cwd = vim.fn.expand("~") }, function(dir) Snacks.picker.files({ cwd = dir }) end) end,
        desc = "Find files in directory (from home)",
      },
      { "<Leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffers" },
      { "<Leader>fh", function() Snacks.picker.help() end, desc = "Find in Neovim help" },
      { "<Leader>fo", function() Snacks.picker.recent() end, desc = "Find old files" },
      { "<Leader>fC", function() Snacks.picker.commands() end, desc = "Find commands" },
      { "<Leader>fk", function() Snacks.picker.keymaps() end, desc = "Find keymaps" },
      {
        "<Leader>fn",
        function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
        desc = "Find files in Neovim config",
      },
      {
        "<Leader>fc",
        function() Snacks.picker.files({ cwd = vim.fn.joinpath(vim.fn.expand("~"), "/dotfiles") }) end,
        desc = "Find files in Dotfiles",
      },
      { "<Leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Find LSP symbols" },
      { "<Leader>fw", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Find LSP workspace symbols" },
      { "<Leader>fr", function() Snacks.picker.lsp_references() end, desc = "Find LSP references" },
      { "<Leader>fe", function() Snacks.picker.diagnostics_buffer() end, desc = "Find diagnostics (Buffer)" },
      { "<Leader>fp", function() Snacks.picker.pickers() end, desc = "Find all pickers" },
      { "<Leader>fE", function() Snacks.picker.diagnostics() end, desc = "Find diagnostics" },
      { "<Leader>fe", function() Snacks.picker.icons() end, desc = "Find emoji" },
      { "<Leader>rr", function() Snacks.picker.grep() end, desc = "Live Grep" },
      {
        "<Leader>rd",
        function() pick_directory({}, function(dir) Snacks.picker.grep({ cwd = dir }) end) end,
        desc = "Grep in directory",
      },
      {
        "<Leader>rD",
        function() pick_directory({ cwd = vim.fn.expand("~") }, function(dir) Snacks.picker.grep({ cwd = dir }) end) end,
        desc = "Grep in directory (from home)",
      },
      {
        "<Leader>rg",
        function()
          Snacks.picker.pick({
            finder = "grep",
            regex = true,
            format = "file",
            show_empty = true,
            live = false,
            supports_live = true,
          })
        end,
        desc = "Grep string",
      },
      { "<Leader>rc", function() Snacks.picker.grep({ cwd = vim.fn.stdpath("config") }) end, desc = "Live Grep in " },
    },
  },
}
