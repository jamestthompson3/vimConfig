local M = {}
local tools = require("tt.tools")

local projects_file = vim.fn.expand("~/.nvim-projects")

local function read_projects()
	local projects = {}
	local file = io.open(projects_file, "r")

	if file then
		for line in file:lines() do
			-- Trim whitespace and skip empty lines
			line = line:match("^%s*(.-)%s*$")
			if line ~= "" then
				table.insert(projects, line)
			end
		end
		file:close()
	end

	return projects
end

local function write_projects(projects)
	-- Remove duplicates while preserving order
	local seen = {}
	local unique_projects = {}

	for _, project in ipairs(projects) do
		if not seen[project] then
			seen[project] = true
			table.insert(unique_projects, project)
		end
	end

	local file = io.open(projects_file, "w")
	if file then
		for _, project in ipairs(unique_projects) do
			file:write(project .. "\n")
		end
		file:close()
		return true
	end

	return false
end

function M.add_current_project()
	local git_root = vim.fs.root(0, ".git")

	if not git_root then
		vim.notify("No git repository found", vim.log.levels.WARN)
		return
	end

	local projects = read_projects()
	table.insert(projects, git_root)

	if write_projects(projects) then
	else
		vim.notify("Failed to write projects file", vim.log.levels.ERROR)
	end
end

function M.remove_project()
	local projects = read_projects()
	if #projects == 0 then
		vim.notify("No projects found. Use :ProjectAdd to add the current directory.", vim.log.levels.INFO)
		return
	end
	local new_projects = {}

	vim.ui.select(projects, {
		prompt = "Remove Project:",
	}, function(choice)
		if choice ~= nil then
			for _, project in ipairs(projects) do
				if project ~= choice then
					table.insert(new_projects, project)
				end
			end

			if write_projects(new_projects) then
				vim.notify("Removed project: " .. choice, vim.log.levels.INFO)
			else
				vim.notify("Failed to write projects file", vim.log.levels.ERROR)
			end
		end
	end)
end

-- Open the projects buffer
function M.show_projects()
	local projects = read_projects()

	if #projects == 0 then
		vim.notify("No projects found. Use :ProjectAdd to add the current directory.", vim.log.levels.INFO)
		return
	end
	vim.ui.select(projects, {
		prompt = "Select Project:",
	}, function(choice)
		if choice ~= nil then
			vim.cmd("cd " .. vim.fn.fnameescape(choice))
			vim.cmd("%bdelete")
			tools.splashscreen()
		end
	end)
end

function M.setup()
	vim.api.nvim_create_user_command("ProjectAdd", function()
		M.add_current_project()
	end, { desc = "Add current git project to projects list" })

	vim.api.nvim_create_user_command("Projects", function()
		M.show_projects()
	end, { desc = "Show all tracked projects" })

	vim.api.nvim_create_user_command("ProjectClear", function()
		M.remove_project()
	end, { desc = "Remove project from list" })
end

return M
