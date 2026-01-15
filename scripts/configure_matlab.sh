#!/bin/bash
set -e

# 1. Create the Desktop Shortcut 
mkdir -p /usr/share/applications
echo "[Desktop Entry]" > /usr/share/applications/matlab.desktop
echo "Version=1.0" >> /usr/share/applications/matlab.desktop
echo "Type=Application" >> /usr/share/applications/matlab.desktop
echo "Name=MATLAB R2023b" >> /usr/share/applications/matlab.desktop
echo "Comment=Scientific Computing" >> /usr/share/applications/matlab.desktop
echo "Exec=/opt/matlab/R2023b/bin/matlab -desktop" >> /usr/share/applications/matlab.desktop
echo "Icon=applications-science" >> /usr/share/applications/matlab.desktop
echo "Terminal=false" >> /usr/share/applications/matlab.desktop
echo "StartupNotify=true" >> /usr/share/applications/matlab.desktop
chmod +x /usr/share/applications/matlab.desktop

# 2. Add MATLAB to Global PATH
echo 'export PATH=/opt/matlab/R2023b/bin:$PATH' >> /etc/bash.bashrc
echo 'export PATH=/opt/matlab/R2023b/bin:$PATH' >> /etc/profile

# 3. Create Startup & License Scripts
mkdir -p /etc/datahub-profile.d

# License File
echo "export MLM_LICENSE_FILE='1700@its-flexlm-lnx1.ucsd.edu'" > /etc/datahub-profile.d/matlab-flexlm.sh

# Icon Restoration Script 
cat <<EOF > /etc/datahub-profile.d/ensure-matlab-icon.sh
#!/bin/bash
mkdir -p ~/Desktop
# Only copy if the file does not exist (prevents overwriting user changes)
if [ ! -f ~/Desktop/matlab.desktop ]; then
   cp /usr/share/applications/matlab.desktop ~/Desktop/
   chmod +x ~/Desktop/matlab.desktop
fi
EOF

chmod +x /etc/datahub-profile.d/ensure-matlab-icon.sh