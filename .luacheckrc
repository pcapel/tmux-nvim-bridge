std = "min"
globals = {
    "vim",
    "unpack",
    "math"
}
exclude_files = {
    "lua/lua-slime/deps/"
}
max_line_length = 999999
max_code_line_length = 999999
max_string_line_length = 999999
max_comment_line_length = 999999
files["**/tests/**/*_spec.lua"].read_globals = {'a'}
files["lua/lua-slime/tests/util.lua"].std = '+busted'
