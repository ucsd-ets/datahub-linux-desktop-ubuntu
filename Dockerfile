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

COPY scripts/ /tmp/scripts/

# Run the System Install Script
RUN chmod +x /tmp/scripts/install_system.sh && \
    /tmp/scripts/install_system.sh

# Run the Configuration Script
RUN chmod +x /tmp/scripts/configure_matlab.sh && \
    /tmp/scripts/configure_matlab.sh

# 3) install packages using notebook user
USER jovyan

#4) Fallback copy
RUN mkdir -p /home/jovyan/Desktop && \
    cp /usr/share/applications/matlab.desktop /home/jovyan/Desktop/ && \
    chmod +x /home/jovyan/Desktop/matlab.desktop

RUN pip install --no-cache-dir networkx scipy jupyter-remote-desktop-proxy

# Override command to disable running jupyter notebook at launch
# CMD ["/bin/bash"]
