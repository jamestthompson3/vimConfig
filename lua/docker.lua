require 'nvim_utils'
require 'navigation'
local api = vim.api
local fn = vim.fn
local loop = vim.loop
local util = require 'nvim_lsp/util'

local M = {}

local function onread(err, data)
  print("Calling on read", err, data)
  if err then
    print('ERROR: ', err)
    -- TODO handle err
  end
  if data then
    print('DATA: ', data)
  end
end

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
      spawn('docker', {
        args = {'pull', image}
      },function()
        print("Image Pulled Successfully")
      end)
    end
  end
  return parsedConfig
end


local function runContainer(name)
  local parsedConfig = M.parseConfig()
  local stdout = loop.new_pipe(false)
  local stderr = loop.new_pipe(false)
  if parsedConfig.workspaceMount:find("localWorkspaceFolder") then
    workspace = api.nvim_exec('pwd', true)
  else
    workspace = parsedConfig.workspaceMount
  end
  local mountFolder = string.format("%s:%s", workspace, parsedConfig.workspaceFolder)
  log(mountFolder)
  handle = loop.spawn('docker', {
    args = {'run', '-it', '-d', '-v', mountFolder, name.image, '/bin/bash'},
    stdio = {stdout,stderr}
  }, function()
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    handle:close()
    print(string.format("Container %s started succesfully", name.name))
  end)
  loop.read_start(stdout, onread)
  loop.read_start(stderr, onread)
end

local function startContainer(name)
  local parsedConfig = M.parseConfig()
  local stdout = loop.new_pipe(false)
  local stderr = loop.new_pipe(false)
  handle = loop.spawn('docker', {
    args = {'start', name.image, '/bin/bash'},
    stdio = {stdout, stderr}
  }, function()
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    handle:close()
    print(string.format("Container %s started succesfully", name.name))
  end)
  loop.read_start(stdout, onread)
  loop.read_start(stderr, onread)
end

function M.attachToContainer()
  local containers = {}
  local foundContainers = fn.systemlist("docker container ls -a --format '{{.Names}} {{.Image}}'")
  if fn.len(foundContainers) == 0 then
    local images = {}
    local foundImages = fn.systemlist("docker image ls -a --format '{{.Repository}}:{{.Tag}} {{.ID}}'")
    for i, image in pairs(foundImages) do
      print(string.format('%d. %s', i, image))
      local repo = vim.split(image, "%s")
      table.insert(images, {name = repo[1], image = repo[2]})
    end
    local selected = tonumber(fn.input("No Containers found, choose an image to build: "))
    runContainer(images[selected])
    return
  end
  for i, container in pairs(foundContainers) do
    print(string.format('%d. %s', i, container))
    local name = vim.split(container, "%s")
    table.insert(containers,{image = name[2], name = name[1]})
  end
  local selected = tonumber(fn.input('Select container number: '))
  if not selected then
    return
  end
  local containerName = containers[selected]
  local containerIsRunning = fn.system("docker container ps --format '{{.Names}}'"):find(containerName.name)
  if not containerIsRunning then
    local containerIsCreated = fn.system("docker container ps -a --format '{{.Names}}'"):find(containerName.name)
    if not containerIsCreated then
      runContainer(containerName)
    else
      startContainer(containerName)
    end
  end
end

function M.buildContainer()
end

M.attachToContainer()

return M
