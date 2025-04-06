-- Terminal setup

-- Configure the terminal mappings inside an autocommand
local group = vim.api.nvim_create_augroup("TerminalSetup", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  -- FIXME(alvaro): We could do something with the pattern to avoid doing this on lazygit
  callback = function(ev)
    -- Skip the lazygit terminal, so that we don't clobber any mappings
    local bufname = vim.api.nvim_buf_get_name(ev.buf)
    if string.find(bufname, "lazygit") then
      return
    end

    -- Setup options and mappings
    vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")
    -- TODO(alvaro): Make this work too
    -- tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
  end,
})
