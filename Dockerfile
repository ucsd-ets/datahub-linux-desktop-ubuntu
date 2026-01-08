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
    rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -y ppa:mozillateam/ppa && \
  echo 'Package: *' > /etc/apt/preferences.d/mozilla-firefox && \
  echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox && \
  echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox && \
  mkdir -p /etc/apt/keyrings && \
  wget -qO /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg && \
  printf "Types: deb deb-src\nURIs: https://qgis.org/ubuntu-ltr\nSuites: $(lsb_release -cs)\nArchitectures: amd64\nComponents: main\nSigned-By: /etc/apt/keyrings/qgis-archive-keyring.gpg\n" > /etc/apt/sources.list.d/qgis.sources && \
  apt-get update && \
  apt-get -y install \
  qgis \
  qgis-plugin-grass \
  htop \
  dbus-x11 \
  xfce4 \
  xfce4-panel \
  xfce4-session \
  xfce4-settings \
  xorg \
  xubuntu-icon-theme \
  tigervnc-standalone-server \
  firefox && \
  df -h && \
  wget https://www.mathworks.com/mpm/glnxa64/mpm && \
  chmod +x mpm && \
  ./mpm install \
  --release=r2023b \
  --destination=/opt/matlab/R2023b \
  --products MATLAB Statistics_and_Machine_Learning_Toolbox \
  && rm -f mpm && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/share/applications && \
    echo "[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=MATLAB R2023b\n\
Comment=Scientific Computing\n\
Exec=/opt/matlab/R2023b/bin/matlab -desktop\n\
Icon=applications-science\n\
Terminal=false\n\
StartupNotify=true" > /usr/share/applications/matlab.desktop && \
    chmod +x /usr/share/applications/matlab.desktop

RUN echo 'export PATH=/opt/matlab/R2023b/bin:$PATH' >> /etc/bash.bashrc && \
    echo 'export PATH=/opt/matlab/R2023b/bin:$PATH' >> /etc/profile

RUN mkdir -p /etc/datahub-profile.d && \
    echo "export MLM_LICENSE_FILE='1700@its-flexlm-lnx1.ucsd.edu'" > /etc/datahub-profile.d/matlab-flexlm.sh && \
    echo '#!/bin/bash' > /etc/datahub-profile.d/ensure-matlab-icon.sh && \
    echo 'mkdir -p ~/Desktop' >> /etc/datahub-profile.d/ensure-matlab-icon.sh && \
    echo 'cp -n /usr/share/applications/matlab.desktop ~/Desktop/ 2>/dev/null || true' >> /etc/datahub-profile.d/ensure-matlab-icon.sh && \
    echo 'chmod +x ~/Desktop/matlab.desktop 2>/dev/null || true' >> /etc/datahub-profile.d/ensure-matlab-icon.sh && \
    chmod +x /etc/datahub-profile.d/ensure-matlab-icon.sh

#RUN sudo add-apt-repository ppa:ungoogled-chromium/ppa && sudo apt update && sudo apt install ungoogled-chromium

# 3) install packages using notebook user
USER jovyan

# RUN conda install -y scikit-learn

RUN mkdir -p /home/jovyan/Desktop && \
    cp /usr/share/applications/matlab.desktop /home/jovyan/Desktop/ && \
    chmod +x /home/jovyan/Desktop/matlab.desktop

RUN pip install --no-cache-dir networkx scipy jupyter-remote-desktop-proxy jupyter-matlab-proxy

# Override command to disable running jupyter notebook at launch
# CMD ["/bin/bash"]
