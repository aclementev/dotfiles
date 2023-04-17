local status, whichkey = pcall(require, "which-key")
if not status then
	return
end

-- Until we know how to start and stop it on demand, we disable it
-- whichkey.setup({})
