-- Some utility functions for general Lua development

--- Escape the special characters in a Lua pattern with a `%` character
local function escape_pattern(text)
    return text:gsub('([^%w])', '%%%1')
end

return {
    escape_pattern=escape_pattern
}
