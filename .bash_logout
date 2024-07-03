#
# ~/.bash_logout
#

# safety before doing an rm -rf
[[ $ff_pidfile == /dev/shm/* ]] && rm -f $ff_pidfile
