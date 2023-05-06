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
M""""""'YMM                   MMP"""""YMM MP""""""`MM 
M  mmmm. `M                   M' .mmm. `M M  mmmmm..M 
M  MMMMM  M .d8888b. dP   .dP M  MMMMM  M M.      `YM 
M  MMMMM  M 88'  `88 88   d8' M  MMMMM  M MMMMMMM.  M 
M  MMMM' .M 88.  .88 88 .88'  M. `MMM' .M M. .MMM'  M 
M       .MM `88888P8 8888P'   MMb     dMM Mb.     .dM 
MMMMMMMMMMM                   MMMMMMMMMMM MMMMMMMMMMM
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
M""""""'YMM                   MMP"""""YMM MP""""""`MM 
M  mmmm. `M                   M' .mmm. `M M  mmmmm..M 
M  MMMMM  M .d8888b. dP   .dP M  MMMMM  M M.      `YM 
M  MMMMM  M 88'  `88 88   d8' M  MMMMM  M MMMMMMM.  M 
M  MMMM' .M 88.  .88 88 .88'  M. `MMM' .M M. .MMM'  M 
M       .MM `88888P8 8888P'   MMb     dMM Mb.     .dM 
MMMMMMMMMMM                   MMMMMMMMMMM MMMMMMMMMMM
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
-------------------------------------------------------------------------
                Done - Please Eject Install Media and Reboot
"
