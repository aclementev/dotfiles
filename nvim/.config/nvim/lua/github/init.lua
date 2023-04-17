-- Functions for the Github Plugin
-- This will include functions to open the current line under the cursor on
-- github (on the default branch remote (origin or upstream))
-- TODO(alvaro): Do we want to support Gitlab as well? Once Github is setup I
--     think we can easily support other styles of URLs, or even accept a function
--     that transforms the remotes into URLS
-- TODO(alvaro): Support for opening files on directories in arbitrary locations
--     in the filesystem, not only taking into account nvim's CWD
local utils = require("alvaro.utils")

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
	return RunCommand("git rev-parse --abbrev-ref HEAD")
end

--- Get the git base's path
local function GitBasePath(add_trailing)
	local result = RunCommand("git rev-parse --show-toplevel")
	if add_trailing then
		return result .. "/"
	else
		return result
	end
end

--- Get the git remote
local function GitRemote()
	return RunCommand("git remote")
end

--- Get the git remote
local function GitRemoteUrl()
	local remote = GitRemote()
	local remote_url = RunCommand("git remote get-url " .. remote)
	return remote_url
end

--- Get the current file's path relative to the git base (as returned by `GitBasePath`)
local function GitFilePath()
	local git_head = GitBasePath(true) -- We ask for a trailing `/`
	local full_path = vim.fn.expand("%:p")
	local normalized_path = full_path:gsub(utils.escape_pattern(git_head), "", 1)
	return normalized_path
end

--- Transfrom a remote configured URL, which could be in SSH-style, to an
--- actual URL that we can open in the browser
local function TransformRemoteGithub(remote_url)
	if not string.find(remote_url, "^https://") then
		-- Transform the SSH-style url to a regular URL
		local url_parts = vim.split(remote_url, ":")
		assert(#url_parts == 2, "invalid format of the remote_url")

		-- TODO(alvaro): Look at the first part, the domain, and do something
		--     smart about it depending on how it looks
		--     For instance, this may not work on ssh custom domains such as
		--     personal.github.com  -> this is an alias defined in .ssh/config
		-- local _domain_url = url_parts[1]
		local repo = url_parts[2]
		-- strip a potential `.git` in the last part of the address
		repo = repo:gsub(".git$", "", 1)
		return "https://github.com/" .. repo
	else
		return remote_url
	end
end

--- Build a Github URL to the contents of the file
local function BuildGithubURL(raw_url, branch, path, lines, url_transformer_fn)
	assert(#lines == 2, "expected a list of 2 line numbers")
	local remote_url = url_transformer_fn(raw_url)
	local github_url = remote_url .. "/blob/" .. branch .. "/" .. path .. "#L" .. lines[1]
	if lines[1] ~= lines[2] then
		-- This was called with a multiple lines selected
		github_url = github_url .. "-L" .. lines[2]
	end
	return github_url
end

--- Open in github the file and line (or range of lines if visual) under
--- the cursor
local function GithubOpen(startl, endl, use_current_branch)
	-- TODO(alvaro): Get the visually selected line
	--      Maybe we could pass it as the arguments using the command instead
	-- TODO(alvaro): Check that the file exists in the version in github
	-- Get the current file path from the git base
	local normalized_path = GitFilePath()
	-- Get the current branch
	local branch = "main"
	if use_current_branch then
		branch = GitBranch()
	end
	-- Get the current remote URL and transform it to a usable
	local raw_url = GitRemoteUrl()
	local github_url = BuildGithubURL(raw_url, branch, normalized_path, { startl, endl }, TransformRemoteGithub)
	--
	-- TODO(alvaro): Handle more platforms
	local open_cmd = "xdg-open" -- Most portable default
	if vim.fn.has("macunix") then
		open_cmd = "open"
	end
	os.execute(open_cmd .. " " .. github_url)
end

return {
	GithubOpen = GithubOpen,
}
