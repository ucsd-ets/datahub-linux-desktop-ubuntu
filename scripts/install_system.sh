#!/bin/bash
set -e 

# 1. Install Prerequisites
apt-get update
apt-get install -y software-properties-common wget gnupg lsb-release
rm -rf /var/lib/apt/lists/*

# 2. Add Repositories (Firefox & QGIS)
add-apt-repository -y ppa:mozillateam/ppa
echo 'Package: *' > /etc/apt/preferences.d/mozilla-firefox
echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox
echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox

mkdir -p /etc/apt/keyrings
wget -qO /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg
printf "Types: deb deb-src\nURIs: https://qgis.org/ubuntu-ltr\nSuites: $(lsb_release -cs)\nArchitectures: amd64\nComponents: main\nSigned-By: /etc/apt/keyrings/qgis-archive-keyring.gpg\n" > /etc/apt/sources.list.d/qgis.sources

# 3. Install System Packages + MATLAB Dependencies
apt-get update
apt-get -y install \
    qgis qgis-plugin-grass \
    htop dbus-x11 \
    xfce4 xfce4-panel xfce4-session xfce4-settings \
    xorg xubuntu-icon-theme tigervnc-standalone-server firefox \
    libgtk-3-0 libasound2 libxtst6 libnss3 libxss1 libxrandr2 libxi6 libxcursor1


# 4. Cleanup to keep image small
rm -f mpm
rm -rf /var/lib/apt/lists/*