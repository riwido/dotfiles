#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
printf "running .bashrc\n"
#set -o vi

is_cmd () {
    command -v $1 > /dev/null
    }



source /usr/share/bash-completion/completions/git

# docker may not be installed
is_cmd docker && source /usr/share/bash-completion/completions/docker

if is_cmd pdm; then
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
if is_cmd fzf; then
    eval "$(fzf --bash)"
else
    printf "fzf not installed yet\n"
fi

alias clip='xclip -selection clipboard'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias va='source .venv/bin/activate'
alias vc='virtualenv .venv'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias ssh='TERM=xterm-256color ssh'

PS1='[\u@\h \W]\$ '
