#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#set -o vi

source /usr/share/bash-completion/completions/git
source /usr/share/bash-completion/completions/docker

source <(pdm completion bash)



gv () {
    a=$(grep -iPr "$1")
    count=$(wc -l <<< $a)
    if [[ -z $a ]] ; then
	printf "No results\n"
    elif [[ $(wc -l <<< $a) -eq 1 ]] ; then
	vim ${a%:*}
    else
    	printf "%s" $a
    fi
    }


mesen () {
    i3-msg "workspace 3; append_layout $HOME/.config/i3/layout-mesen.json"
    Mesen 2>/dev/null &
    firefox 2>/dev/null &
    uxterm 2>/dev/null &
    uxterm 2>/dev/null &
    uxterm 2>/dev/null &
    }


#https://github.com/begin/globbing/blob/master/cheatsheet.md#common-options
shopt -s nocaseglob  # case insensitive match for path expansion

# Set up fzf key bindings and fuzzy completion
command -v fzf >/dev/null && eval "$(fzf --bash)"

alias clip='xclip -selection clipboard'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
