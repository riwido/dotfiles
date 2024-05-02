#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export EDITOR=vim
export VISUAL=vim

#https://github.com/begin/globbing/blob/master/cheatsheet.md#common-options
shopt -s nocaseglob  # case insensitive match for path expansion

# Set up fzf key bindings and fuzzy completion
command -v fzf >/dev/null && eval "$(fzf --bash)"

