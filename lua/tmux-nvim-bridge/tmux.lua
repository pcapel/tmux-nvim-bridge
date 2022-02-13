local utils = require('tmux-nvim-bridge.utils')

local tmux = {}

-- returns a table with the values
-- session_name: the current tmux session
-- window_index: the currently active window index
-- pane_index: the currently active pane index
tmux.current_session = function()
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

tmux.sessions = function()
  if vim.g.tmux_bridge_always_current_session then
    return tmux.current_session().session_name
  else
    return utils.arr_line(vim.fn.system('tmux list-sessions -F "#{session_name}"'))
  end
end

-- Get the windows for a given session
tmux.windows = function(session)
  if vim.g.tmux_bridge_always_current_window then
    return tmux.current_session().window_index
  else
    return utils.arr_line(vim.fn.system(string.format('tmux list-windows -F "#{window_index}" -t %s', session)))
  end
end

tmux.panes = function(session, window)
  utils.pretty_print(session, window)
  local system_panes = utils.arr_line(
    vim.fn.system(
      string.format([[tmux list-panes -t "%s":%s -F '#{pane_index}']], session, window)
    )
  )
  local current = tmux.current_session()
end

-- Selects a pane automatically based on which one is the tallest.
-- I wonder if that heuristic could be configurable?
tmux.auto_panes = function(session, window)
  local panes = {}
  local pane_heights = utils.arr_line(vim.fn.system([[tmux list-panes -t "%s":%s -F '#{pane_height}']], session, window))
  -- we get the valid panes, then we get the active pane and remove it
  -- we don't consider the current pane as valid for sending
  --
end

-- need to sort out what type keys is
tmux.send = function(target, keys)
  vim.fn.system(string.format('tmux send-keys -t %s %s', target, keys))
end

return tmux
