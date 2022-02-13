# Lua Slime
Tslime, but ported to lua.

## Goals
The primary goal of this project is to learn how to develop a plugin in Lua.
However, along the way I do think that it would be nice to improve the
ergonomics of the slime interface.

The first thing that comes to mind is exposing an easier way to switch up the
target session/window/pane.

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


