#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export EDITOR=vim
export VISUAL=vim

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

#https://github.com/begin/globbing/blob/master/cheatsheet.md#common-options
shopt -s nocaseglob  # case insensitive match for path expansion

# Set up fzf key bindings and fuzzy completion
command -v fzf >/dev/null && eval "$(fzf --bash)"

export PATH="$PATH:/home/rwd/.local/bin"

# Add .NET Core SDK tools
export PATH="$PATH:/home/rwd/.dotnet/tools"

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
