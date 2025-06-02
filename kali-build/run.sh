#!/bin/bash

# If ever in the future we connect our server to the hotspot
# then we can use and expand this part of the script to quicky
# setup each device to use the hotspot this will serve to 
# help save on some bandwidth
set_caching()
  {
    # Please note that this config would hardlink connect proxy.
    #https://wiki.debian.org/AptCacherNg
    echo 'Acquire::http { Proxy "http://proxy:3142"; }' | sudo tee -a /etc/apt/apt.conf.d/00proxy
    # on the client side this is all that is required.
    # Setting up Squid Web Caching would be the next thing to config at some point.
    
  }

update_system()
  {
    # This will update the system and install any updates that are available.
    sudo apt update
    sudo apt full-upgrade -y
  }

install_packages()
  {
    # As we will likely be doing some coding Visual Studio Code, will be provided within this script
    sudo apt update
    sudo apt install wget gpg -y
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg

    
    sudo apt update
    # Coding Resources
    sudo apt install -y apt-transport-https python3 code 
    
    # Accessibility
    sudo apt install -y orca brltty espeak-ng onboard

    # Ensuring our scripts can run correctly
    sudo apt install -y dialog xterm

  }

xfce_customization()
  {
    # To understand how I made this function work and help troubleshoot it if it stop working in the future
    # check out the xfconf-query documations https://docs.xfce.org/xfce/xfconf/xfconf-query
    sudo mkdir /usr/share/backgrounds/uww
    sudo cp ./wallpaper/desktop-background.png /usr/share/backgrounds/uww/
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitoreDP-1/workspace0/last-image -s '/usr/share/backgrounds/uww/desktop-background.png'
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitoreDP-1/workspace0/image-style -s '4'
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitoreDP-1/workspace0/color-style -s '0'
    xfconf-query -n -c xfce4-desktop -p /backdrop/screen0/monitoreDP-1/workspace0/rgba1  -t double -s '0.313725' -t double -s '0.113725' -t double -s '0.509804' -t double -s '1.000000'
    xfconf-query -c xfce4-session -np '/shutdown/ShowSuspend' -t 'bool' -s 'false'
    xfconf-query -c xfce4-session -np '/shutdown/ShowHibernate' -t 'bool' -s 'false'
    xfconf-query -c xfce4-session -np '/shutdown/ShowHybridSleep' -t 'bool' -s 'false'
    xfconf-query -c xfwm4 -p /general/workspace_count -s '1'
    xfconf-query -c xfce4-panel -p /plugins/plugin-9/miniature-view -t 'bool' -s 'true'
    #xfconf-query -c xfce4-panel -p /plugins/plugin-9/workspace-scrolling -t 'bool' -s 'false'
    xfconf-query -n -c xfce4-panel -p /panels/dark-mode -t 'bool' -s 'true'
  }

disable_screensaver()
  {
    # This will disable the screensaver and set the power management to never turn off the display.
    xfconf-query -c xfce4-power-manager -p /general/DisplayPowerManagementEnabled -s false
    xfconf-query -c xfce4-power-manager -p /general/DisplayIdleDelay -s 0
    # xfconf-query -c xfce4-power-manager -p /general/HandleDisplayPowerKey -s 'nothing'
    xfconf-query -c xfce4-power-manager -p /general/HandleLidSwitch -s 'nothing'
    xfconf-query -c xfce4-power-manager -p /general/HandleLidSwitchDocked -s 'nothing'
    
    sleep 1; xset s off
    sleep 1; xset s noblank
    sleep 1; xset s noexpose
    sleep 1; xset -dpms
  }
# configure_wifi is an abandoned function.
## 1) it would have required me to store the password in plain text.
## 2) networking need to be setup during install anyway.
configure_wifi() 
  {
    local ssid="$1"
    local password="$2"
    local connection_name="$3"
    
    # Check if network exists
    if ! nmcli device wifi list | grep -q "$ssid"; then
      echo "Network '$ssid' not found"
      return 1
    fi
    
    # Check for existing connection
    if nmcli connection show | grep -q "^name: '$connection_name'"; then
      echo "Connection '$connection_name' already exists. Skipping..."
      return 0
    fi
    
    # Create new connection
    sudo nmcli connection add type wifi con-name "$connection_name" ifname wlan0 wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$password"
    
    # Activate connection
    sudo nmcli connection up "$connection_name"
  }

# This function will setup the disclaimer for the gencyber campers that they have to agree too. 
setting_up_login_banner()
  {
    mkdir -p ~/.config/autostart/
    sudo cp ./agreement_banner.sh /usr/local/bin/agreement
    sudo chmod +x /usr/local/bin/agreement
    cp ./gcyber-agreement.desktop ~/.config/autostart/gcyber-agreement.desktop
  }

# Helper function to help ease the pulling of mac addresses of our machines for reasons.
get_mac_script()
  {
    sudo cp ./get_mac.sh /usr/local/bin/getmac
    sudo chmod +x /usr/local/bin/getmac
  }
  
# for the lastest version of CyberChef please checkout "https://gchq.github.io/CyberChef/"
# we are including a local copy of CyberChef here in order to help maintain we keep
# consistency across all of our devices for camp.
install_CyberChef()
  {
    sudo mkdir -p /opt/cyberchef
    sudo cp -r ./CyberChef/* /opt/cyberchef/
    sudo cp ./cyberchef.desktop /usr/share/applications/
  }

# PLEASE NOTE: Only Functions that are ready for prime time 
# should be included in the main() function unless you are 
# currently testing the code in that function.
#
accessibility()
 {
  mv ./orca-customizations.py ~/.local/share/orca/orca-customizations.py
  
  
  #sudo apt install -y python3-pip


  ##git clone https://github.com/rhasspy/piper.git
  ##cd ./piper/src/python_run
  ##sudo pip install piper-tts
  ##alsa-utils


  # download and install directly from github
  #sudo pip install git+https://github.com/coqui-ai/TTS
  #git clone https://github.com/coqui-ai/TTS.git
  #cd ./TTS
  #sudo pip3 install -r ./requirements.txt
  #sudo pip install TTS  # from PyPI
  #sed -i '$ a\export PATH="~/.local/bin:$PATH"' ~/.bashrc
  #source ~/.bashrc  
 }

main() 
  {
    update_system
    install_packages
    xfce_customization
    disable_screensaver
    setting_up_login_banner
    get_mac_script
    install_CyberChef
  }

main
