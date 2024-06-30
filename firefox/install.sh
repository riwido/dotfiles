#!/usr/bin/env bash

cp firefox.cfg.js /usr/lib/firefox/firefox.cfg.js
chown root:root $_

cp autoconfig.js /usr/lib/firefox/defaults/pref/autoconfig.js
chown root:root $_
