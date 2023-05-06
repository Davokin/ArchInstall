#!/bin/bash
#github-action genshdoc
#
# @file ArchInstall
# @brief Entrance script that launches children scripts for each phase of installation.

# Find the name of the folder the scripts are in
set -a
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCRIPTS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/scripts
CONFIGS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/configs
set +a
echo -ne "
-------------------------------------------------------------------------
                       _      _____              _          
     /\               | |    |_   _|            | |         
    /  \    _ __  ___ | |__    | |   _ __   ___ | |_        
   / /\ \  |  __|/ __||  _ \   | |  |  _ \ / __|| __|       
  / ____ \ | |  | (__ | | | | _| |_ | | | |\__ \| |_        
 /_/    \_\|_|   \___||_| |_||_____||_| |_||___/ \__|       
  _              _____                       _     _        
 | |            |  __ \                     | |   (_)       
 | |__   _   _  | |  | |  __ _ __   __ ___  | | __ _  _ __  
 |  _ \ | | | | | |  | | / _  |\ \ / // _ \ | |/ /| ||  _ \ 
 | |_) || |_| | | |__| || (_| | \ V /| (_) ||   < | || | | |
 |_ __/  \__  | |_____/  \__ _|  \_/  \___/ |_|\_\|_||_| |_|
          __/ |                                             
         |___/                                              
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
-------------------------------------------------------------------------
                Scripts are in directory named ArchInstall
"
    ( bash $SCRIPT_DIR/scripts/startup.sh )|& tee startup.log
      source $CONFIGS_DIR/setup.conf
    ( bash $SCRIPT_DIR/scripts/0-preinstall.sh )|& tee 0-preinstall.log
    ( arch-chroot /mnt $HOME/ArchInstall/scripts/1-setup.sh )|& tee 1-setup.log
    if [[ ! $DESKTOP_ENV == server ]]; then
      ( arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/ArchInstall/scripts/2-user.sh )|& tee 2-user.log
    fi
    ( arch-chroot /mnt $HOME/ArchInstall/scripts/3-post-setup.sh )|& tee 3-post-setup.log
    cp -v *.log /mnt/home/$USERNAME

echo -ne "
-------------------------------------------------------------------------
                       _      _____              _          
     /\               | |    |_   _|            | |         
    /  \    _ __  ___ | |__    | |   _ __   ___ | |_        
   / /\ \  |  __|/ __||  _ \   | |  |  _ \ / __|| __|       
  / ____ \ | |  | (__ | | | | _| |_ | | | |\__ \| |_        
 /_/    \_\|_|   \___||_| |_||_____||_| |_||___/ \__|       
  _              _____                       _     _        
 | |            |  __ \                     | |   (_)       
 | |__   _   _  | |  | |  __ _ __   __ ___  | | __ _  _ __  
 |  _ \ | | | | | |  | | / _  |\ \ / // _ \ | |/ /| ||  _ \ 
 | |_) || |_| | | |__| || (_| | \ V /| (_) ||   < | || | | |
 |_ __/  \__  | |_____/  \__ _|  \_/  \___/ |_|\_\|_||_| |_|
          __/ |                                             
         |___/                                              
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
-------------------------------------------------------------------------
                Done - Please Eject Install Media and Reboot
"
