#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

printf "running .bash_profile\n"

export EDITOR=vim
export VISUAL=vim

export PATH="$PATH:$HOME/.local/bin"

# Add .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

export PATH="/usr/lib/emscripten:$PATH"

cd $HOME/dotfiles

git remote | grep -q public
if [ $? -ne 0 ]; then
    printf "Adding public url for dotfiles\n"
    git remote add public https://github.com/riwido/dotfiles
fi
printf "Updating dotfiles\n"
git pull public main

# go back!
cd -
