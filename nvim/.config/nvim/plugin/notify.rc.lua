local status, notify = pcall(require, "notify")
if not status then
	return
end

notify.setup{
    -- See render styles in documentation
    render = "default",
    stages = "fade_in_slide_out",
    timeout = 5000,
    top_down = true,
}

-- Set notify as the default notification handler for vim
vim.notify = notify

-- Add LSP notification settings
local status, lsp_notify = pcall(require, "lsp-notify")
if not status then
	return
end
lsp_notify.setup()
