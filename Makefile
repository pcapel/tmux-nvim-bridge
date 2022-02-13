lint:
	luacheck lua

test:
	nvim --headless -c "PlenaryBustedDirectory lua/lua-slime/tests/ {minimal_init = 'lua/lua-slime/tests/minimal.vim'}"

format:
	stylua lua/lua-slime/*.lua lua/lua-slime/layout/*.lua lua/lua-slime/redux/*.lua lua/lua-slime/tests/*/*.lua
