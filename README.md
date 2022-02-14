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

# Examples

# Use
## Configuration

# Old Readme
## tslime.vim
This is a simple vim script to send portion of text from a vim buffer to a
running tmux session.

It is based on slime.vim
http://technotales.wordpress.com/2007/10/03/like-slime-for-vim/, but use tmux
instead of screen. However, compared to tmux, screen doesn't have the notion of
panes. So, the script was adapted to take panes into account.

Note: If you use version of tmux earlier than 1.3, you should use the stable
branch. The version available in that branch isn't aware of panes so it will
paste to pane 0 of the window.

# Attributions
I would not have been able to build this out without the code written by the
following awesome developers:

https://github.com/Iron-E
https://github.com/David-Kunz
https://github.com/jgdavey
https://github.com/hoschi

## TODO:
- Wire up the configuration properly
- Figure out how to e2e test with an actual tmux instance
  Maybe a headless terminal? Is there such a thing?
