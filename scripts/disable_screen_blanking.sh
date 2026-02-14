#!/bin/bash
# /etc/datahub-profile.d/02-disable-blanking.sh

# Turn off screen blanking for standard X server
if command -v xset >/dev/null 2>&1; then
   xset s off      # Disable screensaver timer
   xset s noblank  # Disable screen blanking
   xset -dpms      # Disable Energy Star power management
fi

# Apply XFCE specific power management if available
if command -v xfconf-query >/dev/null 2>&1; then
   # Enable Presentation Mode (prevents sleep/blanking)
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