#!/usr/bin/env bash
set -e
[[ -d user.js ]] || git clone https://github.com/pyllyukko/user.js
cd user.js
git pull
cd ..
vimdiff user.js/user.js firefox.cfg.js
