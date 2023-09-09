local dap = require("dap")

dap.adapters.shell = {
  type = "executable",
  command = "bash",
  args = {},
}

dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command =  (os.getenv("VIRTUAL_ENV") and os.getenv("VIRTUAL_ENV") .. "/bin/python") or "/usr/local/bin/python3",
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end


local cwd = vim.fn.getcwd()

-- if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
--   dap.adapters.python.command = cwd .. "/venv/bin/python3"
--   -- print('Loaded venv')
-- elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
--   dap.adapters.python.command = cwd .. "/.venv/bin/python3"
--   -- print('Loaded .venv')
-- else
--   dap.adapters.python.command = "/usr/local/bin/python3"
--   -- print('Loaded system python')
-- end

local function file_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == 'file'
end

local launch_json_file = cwd .. '/.vscode/launch.json'
if file_exists(launch_json_file) then
  dap.configurations.python = vim.fn.json_decode(vim.fn.readfile(launch_json_file)).configurations
  -- print('Loaded launch.json')
else
  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      pythonPath = function()
        if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
          return cwd .. "/venv/bin/python"
        elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
          return cwd .. "/.venv/bin/python"
        else
          return "/usr/local/bin/python3"
        end
      end,
    },
  }
end


dap.adapters["pwa-node"] = {
  type = "server",
  host = "127.0.0.1",
  port = 8123,
  executable = {
    command = "js-debug-adapter",
  }
}

for _, language in ipairs({ "typescript", "javascript" }) do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "node",
    },
  }
end
