# debianMacBookPro11-3-py

Python script version of debianMacBookPro11-3-py

## Notes on the installation of Debian buster (10.3.0) on my MacBook Pro

### Preliminary information

In order to check the hardware configuration, consider using the following commands

```bash
lspci -nn -v | grep <name>
```

**lspci** lists every PCI device with its vendor name (-nn option) and with several verbose modes (-v, -vv, -vvv) according to the level of details needed.
Using some **grep** will help through a keyword to filter. Keywords are Network, PCI bridge, Audio, and so on.
Beside we may obtain other general infomation about the machine. DMI or SMBIOS is invoked via

```bash
sudo dmidecode -s <keyword>
```

where keywords are _bios-vendor, bios-version, bios-release-date, system-manufacturer_, and so on.
For instance

> sudo dmidecode -s system-product-name
> returns
> MacBookPro11,3

### Wireless Network

MacBookPro11,3 mounts _Broadcom Limited BCM4360 802.11ac Wireless Network Adapter_ which is not
supported by open-source firmware. The appropriate firmware is called _wl_ and can be retrieved
with third-party software.
This means that, without a customized debian-installer, it is impossible to do a _netinst_. Of
course the _netinst_ over a LAN ethernet connection works just fine. One we installed the
system we have to add the Wireless Card firmware.
We need to check the presence of some apt packages

```bash
sudo apt-get install wireless-tools network-manager-gnome wpasupplicant
```

which, in case of GNOME environment, should all be present.
We need to add "contrib non-free" to all repos for debian by modifying /etc/apt/sources.list
and add to each "main" a "main contrib non-free" which allows us to get third-party
non-open source software. After a apt-get update and dist-update we can obtain the firmware,
remove conflicting firmwares for other chipsets and add the proper module to the kernel:

```bash
sudo apt-get install broadcom-sta-dkms
sudo modprobe -r b44 b43 b43legacy ssb brcmsmac bcma
sudo modprobe wl
```

The procedures are described at: https://wiki.debian.org/bcm43xx
Compatibility of hardware is listed at: https://wireless.wiki.kernel.org/en/users/drivers/b43

### Adding Font

https://wiki.debian.org/Fonts#Adding_fonts
locale the .ttf
copy it as sudo to /usr/local/share/fonts (sys wide) or ~/.local/share/fonts (user spec)
then run fc-cache

#### For VSCode

add the repo https://github.com/abertsch/Menlo-for-Powerline
install 'Menlo for Powerline' and cache it
then into VSCode search for fontFamily option and set it to 'Menlo for Powerline'

### Graphic Card

### Facetime HD Camera

So far, the best firmware is a custom-made code on github. The repo can be
found at: https://github.com/jbfavre/bcwc_pcie
There is a "debian" branch which can be used to extract and pack-up the
firmware. To clone the branch
The whole instruction set can be found at
https://github.com/patjak/bcwc_pcie/wiki/Get-Started#get-started-on-debian
To load the proper module configuration dat files we need extra work described
here: https://github.com/patjak/bcwc_pcie/wiki/Extracting-the-sensor-calibration-files

### Fn key toggle

Change the state of file /sys/module/hid_apple/parameters/fnmode

1. -> fn access F1,F2 and so on
2. -> fn access lower_brightness, higher_brightness, and so on

#### To make it permanent

> echo options hid_apple fnmode=2 | sudo tee -a /etc/modprobe.d/hid_apple.conf
> sudo update-initramfs -u -k all
