local inputs = {}

-- https://github.com/Iron-E/nvim-libmodal/blob/afe38ffc20b8d28a5436d9b36bf9570e878d0d3a/lua/libmodal/src/Prompt.lua
inputs.createCompletionsProvider = function(completions)
  return function(argLead, cmdLine, _)
    if string.len(cmdLine) < 1 then return completions
    end

    local matches = {}
    for _, completion in ipairs(completions) do
      if string.find(completion, argLead) then
        matches[#matches + 1] = completion
      end
    end
    return matches
  end
end

local function get_input_options(label, options)
  local user_input = ''
  while user_input == '' do
    user_input = vim.fn['tmuxbridge#_inputWith'](label, options)
  end
  return user_input
end

inputs.get_session_name = function(names)
  return get_input_options('session name: ', names)
end

inputs.get_window_index = function(names)
  return get_input_options('window index: ', names)
end

inputs.get_pane_index = function(names)
  return get_input_options('pane index: ', names)
end

return inputs
