-- Quickfix and Loclist configuration
local function entry_under_cursor()
  local cursor_line = vim.fn.line "."
  local qflist = vim.fn.getqflist()

  return qflist[cursor_line]
end

local function open_in_vertical()
  local entry = entry_under_cursor()
  if not entry then
    return
  end

  if not vim.api.nvim_buf_is_valid(entry.bufnr) then
    return
  end

  vim.cmd.wincmd "p"
  vim.cmd.vsplit()
  vim.api.nvim_set_current_buf(entry.bufnr)
  vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
end

local function open_in_horizontal()
  local entry = entry_under_cursor()
  if not entry then
    return
  end

  if not vim.api.nvim_buf_is_valid(entry.bufnr) then
    return
  end

  vim.cmd.wincmd "p"
  vim.cmd.split()
  vim.api.nvim_set_current_buf(entry.bufnr)
  vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
end

local function remove_qf_entry()
  local pos = vim.fn.getpos "."
  local line = pos[2]
  local col = pos[3]
  local old_entries = vim.fn.getqflist()

  local new_entries = {}
  for i, entry in ipairs(old_entries) do
    if i ~= line then
      table.insert(new_entries, entry)
    end
  end

  vim.fn.setqflist(new_entries, "u")
  -- Try to restore the cursor position after deletion
  local target_line = math.min(line, #new_entries)
  local target_entry = new_entries[target_line]
  if not target_entry then
    return
  end

  local target_col = math.min(col, #target_entry.text)
  vim.api.nvim_win_set_cursor(0, { target_line, target_col - 1 })
end

local qf_group = vim.api.nvim_create_augroup("QuickfixSetup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = qf_group,
  pattern = "qf",
  callback = function()
    -- Open the file
    vim.keymap.set("n", "<C-V>", function()
      open_in_vertical()
    end, { buffer = true })
    vim.keymap.set("n", "<C-X>", function()
      open_in_horizontal()
    end, { buffer = true })
    -- TODO(alvaro): Ideally we want to make this more generic, allowing for count and other deletion
    -- actions (e.g. visual selection)
    vim.keymap.set("n", "dd", function()
      remove_qf_entry()
    end, { buffer = true })
  end,
})
