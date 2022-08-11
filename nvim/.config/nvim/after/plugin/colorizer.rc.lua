local status, colorizer = pcall(require, "colorizer")
if (not status) then return end

-- By default it attaches to all filetypes using an autocmd
colorizer.setup()
