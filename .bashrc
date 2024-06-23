#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
printf "running .bashrc\n"
#set -o vi

source /usr/share/bash-completion/completions/git

# docker may not be installed
command -v docker && source /usr/share/bash-completion/completions/docker

if command -v pdm; then
    source <(pdm completion bash)
else
    printf "pdm not installed yet\n"
fi


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
if command -v fzf; then
    eval "$(fzf --bash)"
else
    printf "fzf not installed yet\n"
fi

alias clip='xclip -selection clipboard'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

PS1='[\u@\h \W]\$ '
