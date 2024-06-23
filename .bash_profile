#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export EDITOR=vim
export VISUAL=vim

export PATH="$PATH:/home/rwd/.local/bin"

# Add .NET Core SDK tools
export PATH="$PATH:/home/rwd/.dotnet/tools"

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

export PATH="/usr/lib/emscripten:$PATH"
