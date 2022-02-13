lint:
	luacheck lua

test:
	nvim --headless -c "PlenaryBustedDirectory lua/tmux-nvim-bridge/tests/ {minimal_init = 'lua/tmux-nvim-bridge/tests/minimal.vim'}"

format:
	stylua lua/tmux-nvim-bridge/*.lua lua/tmux-nvim-bridge/layout/*.lua lua/tmux-nvim-bridge/redux/*.lua lua/tmux-nvim-bridge/tests/*/*.lua
