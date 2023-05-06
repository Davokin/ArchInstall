## Create Arch ISO or Use Image

Download ArchISO from <https://archlinux.org/download/> and put on a USB drive with [Etcher](https://www.balena.io/etcher/), [Ventoy](https://www.ventoy.net/en/index.html), or [Rufus](https://rufus.ie/en/)

## Boot Arch ISO

From initial Prompt type the following commands:

```
pacman -Sy git
git clone https://github.com/Davokin/ArchInstall
cd ArchInstall
./archinstall.sh
```

### System Description
This is completely automated arch install. It includes prompts to select your desired desktop environment, window manager, AUR helper, and whether to do a full or minimal install. The KDE and i3 desktop environments on arch include all the packages I use daily, plus some customizations. For the i3 desktop environment, the folders from ArchInstall/configs/ still need to be copied to the appropriate locations afterwards. For example;

#1: Run `sudo cp -r ArchInstall/configs/.config/* $HOME/.config/`
#2: Run `sudo cp -r ArchInstall/tree/main/configs/usr/share/* /usr/share/`
#3: Run `sudo cp -r ArchInstall/configs/etc/* /etc/`

## Troubleshooting

__[Arch Linux RickEllis Installation Guide](https://github.com/rickellis/Arch-Linux-Install-Guide)__

__[Arch Linux Wiki Installation Guide](https://wiki.archlinux.org/title/Installation_guide)__

The main script will generate .log files for every script that is run as part of the installation process. These log files contain the terminal output so you can review any warnings or errors that occurred during installation and aid in troubleshooting. 
### No Wifi

You can check if the WiFi is blocked by running `rfkill list`.
If it says **Soft blocked: yes**, then run `rfkill unblock wifi`

After unblocking the WiFi, you can connect to it. Go through these 5 steps:

#1: Run `iwctl`

#2: Run `device list`, and find your device name.

#3: Run `station [device name] scan`

#4: Run `station [device name] get-networks`

#5: Find your network, and run `station [device name] connect [network name]`, enter your password and run `exit`. You can test if you have internet connection by running `ping google.com`, and then Press Ctrl and C to stop the ping test.

## Reporting Issues

An issue is easier to resolve if it contains a few important pieces of information.
1. Chosen configuration from /configs/setup.conf (DONT INCLUDE PASSWORDS)
1. Errors seen in .log files
1. What commit/branch you used
1. Where you were installing (VMWare, Virtualbox, Virt-Manager, Baremetal, etc)
    1. If a VM, what was the configuration used.
## Credits

- Original packages script was a post install cleanup script called ArchMatic located here: https://github.com/rickellis/ArchMatic
