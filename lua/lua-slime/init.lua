local utils = require('lua-slime.utils')
local vfn = vim.fn

local function as_options(array)
  options = '['
  for i=1, #(array) do
    options = options .. '"' .. array[i] .. '"' .. ','
  end
  return options .. ']'
end

-- returns a table with the values
-- session_name: the current tmux session
-- window_index: the currently active window index
-- pane_index: the currently active pane index
local function active_target()
  local CMD_ACTIVE_TARGET = {
    'tmux list-panes -F "active=#{pane_active} #{session_name},#{window_index},#{pane_index}"',
    'grep "active=1"',
    'cut -d " " -f 2',
    'tr , "\n"',
  }

  local result = utils.arr_line(vfn.system(utils.pipeline(CMD_ACTIVE_TARGET)))

  return {
    session_name = result[1],
    window_index = result[2],
    pane_index = result[3],
  }
end

-- Get the windows for a given session
local function tmux_windows(session)
  if vim.g.tslime_always_current_window then
    return active_target().window_index
  else
    return utils.arr_line(vfn.system('tmux list-windows -F "#{window_index}" -t ' .. session))
  end
end

local function tmux_sessions()
  if vim.g.tslime_always_current_session then
    return active_target().session_name
  else
    return utils.arr_line(vfn.system('tmux list-sessions -F "#{session_name}"'))
  end
end

local function get_session_name(names)
  -- TODO: figure out a better way to do this
  vim.cmd("function! Options(A,L,P)\n" .. "return " .. as_options(names) .. "\nendfunction")

  local user_input = ''
  while user_input == '' do
    user_input = vfn.input('session name: ', '', 'customlist,Options')
  end
  return user_input
end

local function tmux_vars()
  local session_names = tmux_sessions()
  vim.g.tslime = {}
  if #(session_names) == 1 then
    vim.g.tslime['session'] = names[1]
  else
    vim.g.tslime['session'] = get_session_name(session_names)
  end
end

local function run_test()
  get_session_name(tmux_sessions())
end

return {
  run_test = run_test
}
