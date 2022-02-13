local M = {}

-- Utility function for chaining system calls with a pipeline operator
M.pipeline = function(commands)
  local full_command = commands[1]
  for i=2, #(commands) do
    full_command = full_command .. ' | ' .. commands[i]
  end

  return full_command
end

M.arr_line = function(string)
  return vim.fn.split(string, '\n')
end

return M
