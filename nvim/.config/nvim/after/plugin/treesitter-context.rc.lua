local status, tscontext = pcall(require, "treesitter-context")
if not status then
	return
end

tscontext.setup({})
