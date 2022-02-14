nmap <silent> <Plug>NormalModeSendToTmux vip<Plug>SendSelectionToTmux
command! -nargs=* Tmux call Send_to_Tmux('<Args><CR>')

" For debugging, remove later
let ResetBridgeInfo = luaeval("require('tmux-nvim-bridge').reset_tmux_bridge_info")
nnoremap <leader>r :call ResetBridgeInfo()<CR>
vnoremap <leader>f "ry :call TmuxBridge#_send_to_tmux(@r)<CR>

let g:tmux_bridge_always_current_window = 1
let g:tmux_bridge_always_current_session = 1
let g:tmux_bridge_autoset_pane = 1
