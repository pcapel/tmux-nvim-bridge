# Bridge Neovim buffers to Tmux
This is just tslime.vim, but ported to lua.

## Goals
The primary goal of this project is to learn how to develop a plugin in Lua.
Having tried to work with Vimscript, I found it really clunky. I prefer the
explicit requires of lua, as well as the lower verbosity of the language.

There are some very rough corners still, since you also need to use Vimscript
defined functions in certain scenarios. This is especially apparent with the
function passed to `customlist` for user inputs. I found an excellent approach
from Iron-E's `libmodal` project. That was a super helpful pattern.

I've gotten what I was hoping for out of this project with the exception of
figuring out a good way to write end-to-end tests for the plugin. I'll be using
the [vim-slime](https://github.com/jpalardy/vim-slime#kitty) project because of
the support for using kitty. Feel free to read and or use this, but I _will
not_ be maintaining it at all.

# Attributions
I would not have been able to build this out without the code written by the
following awesome developers:

- https://github.com/Iron-E
- https://github.com/David-Kunz
- https://github.com/jgdavey
- https://github.com/hoschi
