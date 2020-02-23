require 'nvim_utils'
require 'navigation'
local api = vim.api
local fn = vim.fn
local util = require 'nvim_lsp/util'

local M = {}

function M.parseConfig()
  if not (util.has_bins("docker")) then
    error("must install docker for this functionality")
  end
  if not (exists("devcontainer.json")) then
    -- TODO interactive creation of config
    print("no configuration file found")
    return
  end
  local parsedConfig = fn.json_decode(fn.join(fn.readfile("devcontainer.json")))
  if not parsedConfig.image or parsedConfig.dockerFile then
    error("must either specify an image or a Dockerfile")
    return
  end
  if parsedConfig.image then
    local image = parsedConfig.image
    local imageExists = fn.system("docker image ls"):find(image)
    if not imageExists then
      print("image not found, installing now...")
      NavigationFloatingWin()
      api.nvim_command(string.format("term docker pull %s", image))
    end
  end
  return parsedConfig
end

function M.attachToContainer()
  local containers = {}
  for i, container in pairs(fn.systemlist("docker container ls -a --format  '{{.Image}}'")) do
    containers[i] = container
    print(string.format('%d: %s', i, container))
  end
  local selected = tonumber(fn.input('Select container number: '))
  local containerName = containers[selected]
  local containerIsRunning = fn.system("docker container ps --format '{{.Image}}"):find(containerName)
  if not containerIsRunning then
    local containerIsCreated = fn.system("docker container ps -a --format '{{.Image}}"):find(containerName)
    if not containerIsCreated then
      print(string.format("Running container %s", containerName))
      fn.system(string.format("docker run %s",containerName))
    else
      print(string.format("Starting container %s", containerName))
      fn.system(string.format("docker start %s",containerName))
    end
  end
end

function M.buildContainer()
end

-- M.attachToContainer()

return M
