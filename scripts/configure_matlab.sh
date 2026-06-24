#!/bin/bash
set -e

# Create profile directory
mkdir -p /etc/datahub-profile.d

# Write dynamic bootstrap script
cat <<'EOF' > /etc/datahub-profile.d/bootstrap-matlab.sh
#!/bin/bash

MOUNT_ROOT="/software/matlab"

# Stop if mount is missing
if [ ! -d "$MOUNT_ROOT" ]; then
   return
fi

# Find newest matlab binary
MATLAB_BIN=$(find "$MOUNT_ROOT" -maxdepth 3 -name "matlab" -type f -executable | sort -r | head -n 1)

if [ -z "$MATLAB_BIN" ]; then
   return
fi

MATLAB_HOME=$(dirname $(dirname "$MATLAB_BIN"))

# Set environment
export MLM_LICENSE_FILE='1700@its-flexlm-lnx1.ucsd.edu'
export PATH="$MATLAB_HOME/bin:$PATH"

# Create Desktop shortcut
mkdir -p ~/Desktop

if [ ! -f ~/Desktop/matlab.desktop ]; then
   cat <<DESKTOP > ~/Desktop/matlab.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=MATLAB (Network)
Comment=Network Mounted from $MATLAB_HOME
Exec=$MATLAB_BIN -desktop
Icon=applications-science
Terminal=false
StartupNotify=true
DESKTOP

   chmod +x ~/Desktop/matlab.desktop

# Turn off screen blanking for desktop 
xset s off      # Disable screensaver timer
xset s noblank  # Disable screen blanking
xset -dpms      # Disable Energy Star power management

if command -v xfconf-query >/dev/null 2>&1; then
   xfconf-query -c xfce4-power-manager \
               -p /xfce4-power-manager/presentation-mode \
               -n -t bool -s true \
               2>/dev/null || true
               
   # Explicitly disable the lock on suspend/sleep
   xfconf-query -c xfce4-session \
               -p /shutdown/LockScreen \
               -n -t bool -s false \
               2>/dev/null || true
fi
EOF

chmod +x /etc/datahub-profile.d/bootstrap-matlab.sh