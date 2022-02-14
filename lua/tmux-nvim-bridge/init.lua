-- A really great addon would be if there was a way to have tmux highlight the
-- panes... It doesn't look like there's a great way to do that without
-- focusing on the pane itself. I would say that the usecase for this whole
-- thing involves having at most three active panes, but what do I know?
local utils = require('tmux-nvim-bridge.utils')
local tmux = require('tmux-nvim-bridge.tmux')
local inputs = require('tmux-nvim-bridge.inputs')

local Plugin = {}
-- TODO: Figure out how the configuration should work.
-- Do you just set those values up on the global scope?
-- Is it better to introduce a way to pass them all around
-- as arguments?
-- I dunno
local defaultConfig = {}

Plugin.setup = function(options)
  Plugin.config = vim.tbl_deep_extend('force', defaultConfig, options or {})
end

local function update_session(new_value)
  vim.g.tmux_bridge_info = utils.replace(vim.g.tmux_bridge_info, 'session', new_value)
end

local function update_pane(new_value)
  vim.g.tmux_bridge_info = utils.replace(vim.g.tmux_bridge_info, 'pane', new_value)
end

-- Exposed API

-- TODO: name this better
Plugin.update_stored_session = function()
  local session_names = tmux.sessions()
  if #(session_names) == 1 then
    update_session(session_names[1])
  else
    update_session(inputs.get_session_name(session_names))
  end
  return vim.g.tmux_bridge_info.session
end

Plugin.update_stored_window = function(current_session)
  local window_names = tmux.windows(current_session)
  local window = #(window_names) == 1 and window_names[1] or inputs.get_window_index(window_names)
  local new_window = vim.fn.substitute(window, ":.*$", '', 'g')

  vim.g.tmux_bridge_info = utils.replace(vim.g.tmux_bridge_info, 'window', new_window)

  return vim.g.tmux_bridge_info.window
end

Plugin.update_stored_pane = function(session, window)
  local available_panes = tmux.panes(session, window)
  if #(available_panes) == 1 then
    update_pane(available_panes[1])
  else
    update_pane(inputs.get_pane_index(available_panes))
  end
  return vim.g.tmux_bridge_info.pane
end

Plugin.reset_tmux_bridge_info = function()
  vim.g.tmux_bridge_info = {}
  local session = Plugin.update_stored_session()
  local window = Plugin.update_stored_window(session)
  local pane = Plugin.update_stored_pane(session, window)
  print(string.format('session: %s, window: %s, pane: %s', session, window, pane))
end

Plugin.send = function(keys)
  if vim.g.tmux_bridge_info == nil then
    Plugin.reset_tmux_bridge_info()
  end
  tmux.send(string.format('"%s"', vim.fn.escape(keys, '\"$')))
end

Plugin.run_test = function()
  Plugin.reset_tmux_bridge_info()
end

return Plugin
