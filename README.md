# Lua Slime
Tslime, but ported to lua.

## Goals
The primary goal of this project is to learn how to develop a plugin in Lua.
However, along the way I do think that it would be nice to improve the
ergonomics of the slime interface.

The first thing that comes to mind is exposing an easier way to switch up the
target session/window/pane. While we _can_ reset them the way the code is
originally written, you have to reset all of them. So if you just want to
target a new pane or something, you're stuck reiterating the info you already
put in. If that's a part of your workflow, it's not nice. I'd like a way to
expose just changing each individual element.

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


