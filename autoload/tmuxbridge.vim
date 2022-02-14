" https://github.com/Iron-E/nvim-libmodal/blob/afe38ffc20b8d28a5436d9b36bf9570e878d0d3a/autoload/libmodal.vim
function! tmuxbridge#_inputWith(indicator, completions)
	function! TmuxBridgeCompletionsProvider(argLead, cmdLine, cursorPos) abort closure
		return luaeval(
		\	'require("tmux-nvim-bridge/inputs").createCompletionsProvider(_A[1])(_A[2], _A[3], _A[4])',
		\	[a:completions, a:argLead, a:cmdLine, a:cursorPos]
		\)
	endfunction

	return input(a:indicator, '', 'customlist,TmuxBridgeCompletionsProvider')
endfunction

let TmuxBridge#_send_to_tmux = luaeval('require("tmux-nvim-bridge").send')
