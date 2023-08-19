local setup, vtext = pcall(require, "nvim-dap-virtual-text")
if not setup then
	return
end

vtext.setup {
    virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol'
}
