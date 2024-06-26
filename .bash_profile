#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

printf "running .bash_profile\n"


# Set defaults here.  Tried to use ${FOO:-BAR} with envsubst but it didn't work
# envsubst < <(echo '${foo:-bar}')
export bar_intf=_first_

# Override any defaults with a .localrc
[[ -f ~/.localrc ]] && . ~/.localrc

export EDITOR=vim
export VISUAL=vim

export PATH="$PATH:$HOME/.local/bin"

# Add .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

export PATH="/usr/lib/emscripten:$PATH"

export ramfs_tmp=/dev/shm/$USER
[[ -d $ramfs_tmp ]] || (mkdir -p $ramfs_tmp && chmod 700 $ramfs_tmp)

export ff_pidfile=${ramfs_tmp}/ffpids
export active_class=${ramfs_tmp}/active_class

cd $HOME/dotfiles

git remote | grep -q public
if [ $? -ne 0 ]; then
    printf "Adding public url for dotfiles\n"
    git remote add public https://github.com/riwido/dotfiles
fi
printf "Updating dotfiles\n"
git pull public main


# go back!
cd ~
