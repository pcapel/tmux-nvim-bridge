local utils = require('lua-slime.utils')
local vfn = vim.fn

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

local function tmux_windows()
  if vim.g.tslime_always_current_window then
    return active_target.window_index
  else
    return utils.arr_line(vfn.system('tmux list-sessions -F "#{session_name}"'))
  end
end

-- local function send_key_to_tmux(key, tmux_target)
--   if not vim.fn.exists('g:tslime') then
--     tmux_vars()
--   end

--   local res = vim.cmd(':call system("tmux send-keys -t ' .. tmux_target .. key .. '")')
-- end


local function run_test()
  for key, value in pairs(tmux_windows()) do
    print(key, value)
  end
end

return {
  run_test = run_test
}
