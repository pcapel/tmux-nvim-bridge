set rtp +=.
set rtp +=../plenary.nvim/

"lua vim.fn.setenv("DEBUG_PLENARY", true)
runtime! plugin/plenary.vim
runtime! plugin/tmux-nvim-bridge.vim

set noswapfile
set nobackup
set nowritebackup

set hidden
color peachpuff

lua << EOF
require('tmux-nvim-bridge')
EOF
