local utils = require('tmux-nvim-bridge.utils')

local M = {}

-- returns a table with the values
-- session_name: the current tmux session
-- window_index: the currently active window index
-- pane_index: the currently active pane index
M.session_info = function()
  local system_info = utils.arr_line(
    vim.fn.system(
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
M.windows = function(session)
  if vim.g.tmux_bridge_always_current_window then
    return M.session_info().window_index
  else
    return utils.arr_line(vim.fn.system(string.format('tmux list-windows -F "#{window_index}" -t %s', session)))
  end
end

M.sessions = function()
  if vim.g.tmux_bridge_always_current_session then
    return M.session_info().session_name
  else
    return utils.arr_line(vim.fn.system('tmux list-sessions -F "#{session_name}"'))
  end
end

-- need to sort out what type keys is
M.send = function(keys)
  vim.fn.system(string.format('tmux send-keys -t %s %s', tmux_target(), keys))
end

return M
