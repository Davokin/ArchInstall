#!/usr/bin/env bash
#github-action genshdoc
#
# @file User
# @brief User customizations and AUR package installation.
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
                        SCRIPTHOME: ArchInstall
-------------------------------------------------------------------------

Installing AUR Softwares
"
source $HOME/ArchInstall/configs/setup.conf

  cd ~
  mkdir "/home/$USERNAME/.cache"
  touch "/home/$USERNAME/.cache/zshhistory"
  git clone "https://github.com/ChrisTitusTech/zsh"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  ln -s "~/zsh/.zshrc" ~/.zshrc

sed -n '/'$INSTALL_TYPE'/q;p' ~/ArchInstall/pkg-files/${DESKTOP_ENV}.txt | while read line
do
  if [[ ${line} == '--END OF MINIMAL INSTALL--' ]]
  then
    # If selected installation type is FULL, skip the --END OF THE MINIMAL INSTALLATION-- line
    continue
  fi
  echo "INSTALLING: ${line}"
  sudo pacman -S --noconfirm --needed ${line}
done


if [[ ! $AUR_HELPER == none ]]; then
  cd ~
  git clone "https://aur.archlinux.org/$AUR_HELPER.git"
  cd ~/$AUR_HELPER
  makepkg -si --noconfirm
  # sed $INSTALL_TYPE is using install type to check for MINIMAL installation, if it's true, stop
  # stop the script and move on, not installing any more packages below that line
  sed -n '/'$INSTALL_TYPE'/q;p' ~/ArchInstall/pkg-files/aur-pkgs.txt | while read line
  do
    if [[ ${line} == '--END OF MINIMAL INSTALL--' ]]; then
      # If selected installation type is FULL, skip the --END OF THE MINIMAL INSTALLATION-- line
      continue
    fi
    echo "INSTALLING: ${line}"
    $AUR_HELPER -S --noconfirm --needed ${line}
  done
fi

export PATH=$PATH:~/.local/bin

# Theming DE if user chose FULL installation
if [[ $INSTALL_TYPE == "FULL" ]]; then
  if [[ $DESKTOP_ENV == "kde" ]]; then
    cp -r ~/ArchInstall/configs/.config/* ~/.config/
    cp -r ~/ArchInstall/configs/etc/* /etc/
    mkdir -p /usr/share/rofi/themes/
    cp -r ~/ArchInstall/configs/usr/share/rofi/themes/* /usr/share/rofi/themes/
    pip install konsave
    konsave -i ~/ArchInstall/configs/kde.knsv
    sleep 1
    konsave -a kde
  elif [[ $DESKTOP_ENV == "openbox" ]]; then
    cd ~
    git clone https://github.com/stojshic/dotfiles-openbox
    ./dotfiles-openbox/install-titus.sh
  fi
fi

echo -ne "
-------------------------------------------------------------------------
                    SYSTEM READY FOR 3-post-setup.sh
-------------------------------------------------------------------------
"
exit
