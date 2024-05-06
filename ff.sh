#!/usr/bin/env bash

cd ~/.mozilla/firefox
git clone https://github.com/pyllyukko/user.js
ln -s ../user.js/user.js $(ls | grep default-release)/user.js
