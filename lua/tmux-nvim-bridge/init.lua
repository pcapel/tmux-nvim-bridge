-- Questions About Plugin Development
-- 1. Why use the vim.g var everywhere? Is it just because there is no concept
-- of state? Is that why the yode source uses a weird redux analog?
local utils = require('tmux-nvim-bridge.utils')
local tmux = require('tmux-nvim-bridge.interactors')
local pp = function(...)
   for i = 1, select('#', ...) do
        print(vim.inspect(select(i, ...)))
    end
end

-- from:
-- https://github.com/Iron-E/nvim-libmodal/blob/afe38ffc20b8d28a5436d9b36bf9570e878d0d3a/lua/libmodal/src/Prompt.lua
local function createCompletionsProvider(completions)
  return function(argLead, cmdLine, _)
    if string.len(cmdLine) < 1 then return completions
    end

    matches = {}
    for _, completion in ipairs(completions) do
      if string.find(completion, argLead) then
        matches[#matches + 1] = completion
      end
    end
    return matches
  end
end

local function get_input_options(value_label, options)
  local user_input = ''
  while user_input == '' do
    user_input = vim.fn['tmuxbridge#_inputWith'](value_label, options)
  end
  return user_input
end

local function get_session_name(names)
  return get_input_options('session name: ', names)
end

local function get_window_name(names)
  return get_input_options('window name: ', names)
end

local function update_stored_session()
  local session_names = tmux.sessions()
  if #(session_names) == 1 then
    vim.g.tmux_bridge_info = utils.replace(vim.g.tmux_bridge_info, 'session', session_names[1])
  else
    vim.g.tmux_bridge_info = utils.replace(vim.g.tmux_bridge_info, 'session', get_session_name(session_names))
  end
  return vim.g.tmux_bridge_info.session
end

local function update_stored_window(current_session)
  local window_names = tmux.windows(current_session)

  local window = nil
  if #(window_names) == 1 then
    window = window_names[1]
  else
    window = get_window_name(window_names)
  end
  return vim.fn.substitute(window, ":.*$", '', 'g')
end

local function reset_tmux_bridge_info()
  vim.g.tmux_bridge_info = {}
  update_stored_pane(
    update_stored_window(
      update_stored_session()
    )
  )
  for key, value in pairs(vim.g.tmux_bridge_info) do
    print(key, value)
  end
end

local function run_test()
  vim.g.tmux_bridge_info = {}
  update_stored_session()
  -- reset_tmux_bridge_info()
end

return {
  run_test = run_test,
  reset_tmux_bridge_info = reset_tmux_bridge_info,
  updated_stored_session = update_stored_session,
  updated_stored_window = update_stored_window,
  updated_stored_pane = update_stored_pane,
  createCompletionsProvider = createCompletionsProvider,
}
