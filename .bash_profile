#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

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



# Keep packages lined up.  Separate by not-gui/gui
readarray -t installed < <(pacman -Q | cut -d' ' -f1)

# list all packages explicity installed and not required as dependencies
readarray -t extras < <(pacman -Qet | cut -d' ' -f1)

readarray -t apps < apps
readarray -t xapps < xapps

for extra in "${extras[@]}"; do
    if ! [[ " ${apps[*]} " =~ " $extra " ]] && ! [[ " ${xapps[*]} " =~ " $extra " ]]; then
        printf "Extra app installed: %s\n" $extra
    fi
done

missing=0
while read app; do
    if ! [[ " ${installed[*]} " =~ " $app " ]]; then
        printf "Warning: %s not installed\n" $app
        missing=1
    fi
done < apps

if [[ $missing -eq 1 ]]; then
    printf 'resolve:\npacman -S $(<dotfiles/apps)\n'
fi

xmissing=0
if [[ " ${installed[*]} " =~ " xorg-server " ]]; then
    while read app; do
        if ! [[ " ${installed[*]} " =~ " $app " ]]; then
            printf "Warning: %s not installed\n" $app
            xmissing=1
        fi
    done < xapps
fi
if [[ $xmissing -eq 1 ]]; then
    printf 'resolve:\npacman -S $(<dotfiles/xapps)\n'
fi

# all links accounted for?
cat links.sh | grep ^ln | cut -d' ' -f4 | while read link; do
    test -e ${link/\~/$HOME} || echo "missing ${link} from ~/dotfiles/links.sh"
done

cmp motd/create_motd /usr/bin/create_motd || echo "motd/create_motd out of date"

# go back!
cd ~

if ! [[ -e .vim/.venv ]]; then
    mkdir -p .vim
    cd .vim
    virtualenv .venv
    . .venv/bin/activate
    pip install pynvim black
    deactivate
    cd ..
fi
