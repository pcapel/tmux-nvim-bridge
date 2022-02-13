-- Questions About Plugin Development
-- 1. Why use the vim.g var everywhere? Is it just because there is no concept
-- of state? Is that why the yode source uses a weird redux analog?
--
-- 2. There must be better ways to interact with things like customlist. My
-- hack is gross and I hate it.
local utils = require('lua-slime.utils')
local vfn = vim.fn

-- returns a table with the values
-- session_name: the current tmux session
-- window_index: the currently active window index
-- pane_index: the currently active pane index
local function active_session_info()
  local system_info = utils.arr_line(
    vfn.system(
      utils.pipeline {
        'tmux list-panes -F "active=#{pane_active} #{session_name},#{window_index},#{pane_index}"',
        'grep "active=1"',
        'cut -d " " -f 2',
        'tr , "\n"',
      }
    )
  )

  return {
    session_name = system_info[1],
    window_index = system_info[2],
    pane_index = system_info[3],
  }
end

-- Get the windows for a given session
local function tmux_windows(session)
  if vim.g.tslime_always_current_window then
    return active_session_info().window_index
  else
    return utils.arr_line(vfn.system(stirng.format('tmux list-windows -F "#{window_index}" -t %s', session)))
  end
end

local function tmux_sessions()
  if vim.g.tslime_always_current_session then
    return active_session_info().session_name
  else
    return utils.arr_line(vfn.system('tmux list-sessions -F "#{session_name}"'))
  end
end

OPTIONS = "function! Options(A,L,P)\nreturn %s\nendfunction"

local function get_input_options(value_label, options)
  -- TODO: figure out a better way to do this
  vim.cmd(string.format(OPTIONS, utils.as_str_array(options)))

  local user_input = ''
  while user_input == '' do
    user_input = vfn.input(value_label, '', 'customlist,Options')
  end
  return user_input
end

local function get_session_name(names)
  return get_input_options('session name: ', names)
end

local function get_window_name(names)
  return get_input_options('window name: ', names)
end

-- need to sort out what type keys is
local function send_to_tmux(keys)
  vfn.system(string.format('tmux send-keys -t %s %s', tmux_target(), keys))
end

local function update_stored_session()
  local session_names = tmux_sessions()
  if #(session_names) == 1 then
    vim.g.tmux_send_info = utils.replace(vim.g.tmux_send_info, 'session', session_names[1])
  else
    vim.g.tmux_send_info = utils.replace(vim.g.tmux_send_info, 'session', get_session_name(session_names))
  end
  return vim.g.tmux_send_info['session']
end

local function update_stored_window(current_session)
  local window_names = tmux_windows(current_session)

  local window = nil
  if #(window_names) == 1 then
    window = windows[1]
  else
    window = get_window_name(window_names)
  end
  return vim.fn.substitute(window, ":.*$", '', 'g')
end

local function reset_tmux_send_info()
  vim.g.tmux_send_info = {}
  update_stored_pane(
    update_stored_window(
      update_stored_session()
    )
  )
  for key, value in pairs(vim.g.tmux_send_info) do
    print(key, value)
  end
end

local function run_test()
  vim.g.always_current_window
  reset_tmux_send_info()
end

return {
  run_test = run_test,
  reset_tmux_send_info = reset_tmux_send_info,
  updated_stored_session = update_stored_session,
  updated_stored_window = update_stored_window,
  updated_stored_pane = update_stored_pane,

}
