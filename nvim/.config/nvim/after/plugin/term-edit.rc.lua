local status, tedit = pcall(require, "term-edit")
if not status then
	return
end

-- FIXME(alvaro): I think we could guess this by using $PROMPT?
tedit.setup({
	prompt_end = "❯ ",
})
