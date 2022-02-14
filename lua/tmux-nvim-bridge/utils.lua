local utils = {}

utils.pipeline = function(commands)
  local full_command = commands[1]
  for i=2, #(commands) do
    full_command = full_command .. ' | ' .. commands[i]
  end

  return full_command
end

utils.arr_line = function(string)
  return vim.fn.split(string, '\n')
end

utils.as_str_array = function(array)
  local element = '%q,'
  local options = '['
  for i=1, #(array) do
    options = options .. string.format(element, array[i])
  end
  return options .. ']'
end

utils.replace = function(table, key, value)
  local new_table = {}
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

utils.pretty_print = function(...)
  for i = 1, select('#', ...) do
    print(vim.inspect(select(i, ...)))
  end
end

return utils
