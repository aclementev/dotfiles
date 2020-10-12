-- Functions for the Github Plugin
-- This will include functions to open the current line under the cursor on
-- github (on the default branch remote (origin or upstream))
-- TODO(alvaro): Do we want to support Gitlab as well? Once Github is setup I
--     think we can easily support other styles of URLs, or even accept a function
--     that transforms the remotes into URLS

--- Run a simple command and return the result
local function RunCommand(cmd)
    local fd = io.popen(cmd)
    -- TODO(alvaro): Should we trim this result here?
    local result = vim.trim(fd:read())
    fd:close()
    return result
end


--- Get the current checked out branch name
local function GitBranch()
    return RunCommand('git rev-parse --abbrev-ref HEAD')
end

--- Get the git base's path
local function GitBasePath(add_trailing)
    local result = RunCommand('git rev-parse --show-toplevel')
    if add_trailing then
        return result .. '/'
    else
        return result
    end
end

--- Get the git remote
local function GitRemote()
    return RunCommand('git remote')
end


--- Get the git remote
local function GitRemoteUrl()
    local remote = GitRemote()
    local remote_url = RunCommand('git remote get-url ' .. remote)
    return remote_url
end

--- Get the current file's path relative to the git base (as returned by `GitBasePath`)
local function GitFilePath()
    local git_head = GitBasePath(true) -- We ask for a trailing `/`
    local full_path = vim.fn.expand('%:p')
    local normalized_path = string.gsub(full_path, git_head, '', 1)
    return normalized_path
end

--- Transfrom a remote configured URL, which could be in SSH-style, to an
--- actual URL that we can open in the browser
local function TransformRemoteGithub(remote_url)
    if not string.find(remote_url, '^https://') then
        -- Transform the SSH-style url to a regular URL
        local url_parts = vim.split(remote_url, ':')
        assert(#url_parts == 2, "invalid format of the remote_url")

        local base_url = url_parts[1]
        local repo = url_parts[2]
        return 'https://' .. base_url .. '/' .. repo
    else
        return remote_url
    end
end

--- Build a Github URL to the contents of the file
local function BuildGithubURL(raw_url, branch, path, line, url_transformer_fn)
    local remote_url = url_transformer_fn(raw_url)
    -- TODO(alvaro): Accept line as a list
    return remote_url .. '/blob/' .. branch .. '/' .. path .. '#L' .. line
end

--- Open in github the file and line (or range of lines if visual) under
--- the cursor
local function GithubOpen()
    -- TODO(alvaro): Get the visually selected line
    --      Maybe we could pass it as the arguments using the command instead
    -- TODO(alvaro): Check that the file exists in the version in github

    local line = vim.fn.getpos('.')[2]
    -- Get the current file path from the git base
    local normalized_path = GitFilePath()
    -- Get the current branch
    local branch = GitBranch()
    -- Get the current remote URL and transform it to a usable
    local raw_url = GitRemoteUrl()
    local github_url = BuildGithubURL(raw_url,
                                      branch,
                                      normalized_path,
                                      line,
                                      TransformRemoteGithub)
    -- TODO(alvaro): Handle better the open command for multi platform compat
    os.execute('xdg-open ' .. github_url)
end


return {
    GithubOpen=GithubOpen
}
