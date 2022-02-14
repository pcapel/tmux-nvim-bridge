vnoremap <silent> <Plug>SendSelectionToTmux "ry :call Send_to_Tmux(@r)
nmap <silent> <Plug>NormalModeSendToTmux vip<Plug>SendSelectionToTmux
command! -nargs=* Tmux call Send_to_Tmux('<Args><CR>')

let ResetBridgeInfo = luaeval("require('tmux-nvim-bridge').reset_tmux_bridge_info")
nnoremap <leader>r :call ResetBridgeInfo()<CR>
vnoremap <leader>f <Plug>SendSelectionToTmux
