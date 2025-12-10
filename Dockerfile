# 1) choose base container
# generally use the most recent tag

# base notebook, contains Jupyter and relevant tools
# See https://github.com/ucsd-ets/datahub-docker-stack/wiki/Stable-Tag 
# for a list of the most current containers we maintain
ARG BASE_CONTAINER=ghcr.io/ucsd-ets/datascience-notebook:stable 

FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

# 2) change to root to install packages
USER root

RUN apt-get update && \
  apt-get install -y software-properties-common wget gnupg lsb-release && \
  add-apt-repository -y ppa:mozillateam/ppa && \
  echo 'Package: *' > /etc/apt/preferences.d/mozilla-firefox && \
  echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox && \
  echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox && \
  mkdir -p /etc/apt/keyrings && \
  wget -qO /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg && \
  echo "Types: deb deb-src\nURIs: https://qgis.org/ubuntu-ltr\nSuites: $(lsb_release -cs)\nArchitectures: amd64\nComponents: main\nSigned-By: /etc/apt/keyrings/qgis-archive-keyring.gpg" > /etc/apt/sources.list.d/qgis.sources && \  apt-get update && \
  apt-get -y install \
  htop \
  dbus-x11 \
  xfce4 \
  xfce4-panel \
  xfce4-session \
  xfce4-settings \
  xorg \
  xubuntu-icon-theme \
  tigervnc-standalone-server \
  firefox \
  && rm -rf /var/lib/apt/lists/*

#RUN sudo add-apt-repository ppa:ungoogled-chromium/ppa && sudo apt update && sudo apt install ungoogled-chromium

# 3) install packages using notebook user
USER jovyan

# RUN conda install -y scikit-learn

RUN pip install --no-cache-dir networkx scipy jupyter-remote-desktop-proxy

# Override command to disable running jupyter notebook at launch
# CMD ["/bin/bash"]
