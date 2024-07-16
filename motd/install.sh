#!/usr/bin/env bash

if [[ $UID == 0 ]]; then
    cp create_motd /usr/bin/create_motd
    chmod +x /usr/bin/create_motd
    cp create_motd.service /etc/systemd/system/create_motd.service
    chown root:root /usr/bin/create_motd
    chown root:root /etc/systemd/system/create_motd.service
    systemctl enable --now create_motd.service
else
    >&2 echo "Run as root"
fi
