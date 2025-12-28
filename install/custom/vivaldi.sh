#!/usr/bin/env bash
set -euo pipefail

mkdir -p ~/temp_install
wget -O ~/temp_install/vivaldi.deb \
	https://vivaldi.com/download/vivaldi-stable_amd64.deb

sudo apt install -y ~/temp_install/vivaldi.deb
rm -rf ~/temp_install
