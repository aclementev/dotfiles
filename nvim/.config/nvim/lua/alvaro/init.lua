-- Show the current clients attached the the
_G.lsp_buf_show_clients = function()
	vim.print(vim.lsp.get_clients())
end

_G.P = function(value)
	vim.print(value)
	return value
end

-- Load the relevant part of the configuration
require("alvaro.terminal")
