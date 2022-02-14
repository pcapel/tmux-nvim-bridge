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

-- Returns a table with
-- { session_name } as strings
tmux.sessions = function()
  if vim.g.tmux_bridge_always_current_session then
    return {tmux.current_session().session_name}
  else
    return utils.arr_line(vim.fn.system('tmux list-sessions -F "#{session_name}"'))
  end
end

-- Returns a table with
-- { window_index } as strings
tmux.windows = function(session)
  if vim.g.tmux_bridge_always_current_window then
    return {tmux.current_session().window_index}
  else
    return utils.arr_line(vim.fn.system(string.format('tmux list-windows -F "#{window_index}" -t %s', session)))
  end
end

-- This doesn't work for pane filtering when we're using the autofilter.
-- Is there a way around that?
local function filter_current(key, collection)
  local current = tmux.current_session()

  local filtered = {}
  for _, item in ipairs(collection) do
    if item ~= current[key] then
      filtered[#filtered + 1] = item
    end
  end
  return filtered
end

-- Selects a pane automatically based on which one is the tallest.
-- I wonder if that heuristic could be configurable?
tmux.auto_panes = function(session, window)
  local current_pane_index = tmux.current_session().pane_index
  local panes = {}
  local pane_heights = utils.arr_line(
    vim.fn.system(
      string.format(
        [[tmux list-panes -t "%s":%s -F '#{pane_index},#{pane_height}']],
        session,
        window
      )
    )
  )
  for _,height in ipairs(pane_heights) do
    local split = vim.fn.split(height, ',')
    panes[split[1]] = vim.fn.str2nr(split[2])
  end

  local selection = nil
  if vim.g.autopane_function then
    selection = vim.g.autopane_function(panes)
  else
    local biggest = 0
    for pane_index, pane_height in pairs(panes) do
      if pane_height > biggest and pane_index ~= current_pane_index then
        biggest = pane_height
        selection = pane_index
      end
    end
  end
  return {selection}
end

-- Pane filtering could be left up to a middle-ware
-- though the base case of ignoring the active pane
-- is probably always reasonable
tmux.panes = function(session, window)
  if vim.g.tmux_bridge_autoset_pane then
    return tmux.auto_panes(session, window)
  else
    local system_panes = utils.arr_line(
    vim.fn.system(
        string.format(
          [[tmux list-panes -t "%s":%s -F '#{pane_index}']],
          session,
          window
        )
      )
    )
    return filter_current('pane_index', system_panes)
  end
end

tmux.target = function()
  local info = vim.g.tmux_bridge_info
  return string.format('"%s":%s.%s', info.session, info.window, info.pane)
end

-- need to sort out what type keys is
tmux.send = function(keys)
  local target = tmux.target()
  vim.fn.system(string.format('tmux send-keys -t %s %s', target, keys))
end

return tmux
