local utils = require('tmux-nvim-bridge.utils')
local tmux = require('tmux-nvim-bridge.tmux')
local inputs = require('tmux-nvim-bridge.inputs')

local Plugin = {}
local defaultConfig = {}

Plugin.setup = function(options)
  Plugin.config = vim.tbl_deep_extend('force', defaultConfig, options or {})
end

local function update_session(new_value)
  vim.g.tmux_bridge_info = utils.replace(vim.g.tmux_bridge_info, 'session', new_value)
end

local function update_stored_session()
  local session_names = tmux.sessions()
  if #(session_names) == 1 then
    update_session(session_names[1])
  else
    update_session(inputs.get_session_name(session_names))
  end
  return vim.g.tmux_bridge_info.session
end

local function update_stored_window(current_session)
  local window_names = tmux.windows(current_session)
  local window = #(window_names) == 1 and window_names[1] or inputs.get_window_name(window_names)
  local new_window = vim.fn.substitute(window, ":.*$", '', 'g')

  utils.replace(vim.g.tmux_bridge_info, 'window', new_window)

  return vim.g.tmux_bridge_info.window
end

local function update_stored_pane()
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
  -- reset_tmux_bridge_info()
  local c = tmux.current_session()
  tmux.panes(c.session_name, c.window_index)
end

return {
  run_test = run_test,
  reset_tmux_bridge_info = reset_tmux_bridge_info,
  updated_stored_session = update_stored_session,
  updated_stored_window = update_stored_window,
  updated_stored_pane = update_stored_pane,
}
