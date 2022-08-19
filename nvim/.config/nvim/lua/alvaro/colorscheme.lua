-- Colorscheme setup
-- We use a simple file based system to automatically detect the preference
-- of light vs dark mode for the editor colorscheme
-- TODO(alvaro): Automatically detect changes of the screen mode
-- Can we set up a watcher on the `SCREEN_MODE_FILE` to listen to file
-- changes?
-- Another option is to Refresh the colorscheme on some kind of WinEnter,
-- TabEnter, FocusGained events so that it's lazy
vim.o.termguicolors = true

local DEFAULT_MODE = 'dark'
local SCREEN_MODE_FILE = vim.fn.expand("~/.alvaro_screen_mode")

local function load_mode()
    if vim.fn.filereadable(SCREEN_MODE_FILE) == 0 then
        -- No file specified, so just return the default
        return DEFAULT_MODE
    end

    -- Try to load the value from the file
    local lines = vim.fn.readfile(SCREEN_MODE_FILE)
    if #lines ~= 1 then
        print("Invalid screen mode format")
        return DEFAULT_MODE
    else
        local mode = lines[1]
        if mode == "light" then
            return "light"
        elseif mode == "dark" then
            return "dark"
        else
            print("Invalid screen mode value '" .. mode .. "'")
            return DEFAULT_MODE
        end
    end
end

function RefreshColorscheme()
    local mode = load_mode()
    if mode == 'dark' then
        -- Apply the ayu-mirage colorscheme
        vim.o.background = 'dark'
        vim.g.ayucolor = 'mirage'
        vim.cmd [[ colorscheme ayu ]]
    elseif mode == 'light' then
        -- Apply the solarized light colorscheme
        vim.o.background = 'light'
        vim.cmd [[ colorscheme solarized ]]
    else
        print("Unexpected color mode value! '" .. mode .. "'")
    end
end

-- Register a command for refreshing the colorscheme
vim.api.nvim_create_user_command('RefreshColorscheme', RefreshColorscheme, { nargs = 0 })

-- Actually apply the colorscheme
RefreshColorscheme()
