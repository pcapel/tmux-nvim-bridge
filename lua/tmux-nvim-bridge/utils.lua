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

M.as_str_array = function(array)
  element = '%q,'
  local options = '['
  for i=1, #(array) do
    options = options .. string.format(element, array[i])
  end
  return options .. ']'
end

M.replace = function(table, key, value)
  new_table = {}
  for label, entry in pairs(table) do
    if label == key then
      new_table[label] = value
    else
      new_table[label] = entry
    end
  end
  if table[key] == nil then
    new_table[key] = value
  end
  return new_table
end

return M
