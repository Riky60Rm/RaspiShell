# RaspiShell
Shell used to customize a fresh flashed Raspberry pi OS 

tired of manual operation to install and configure Raspi OS I wrote two Shells :

1) PrepareNewIso.sh
which has to launched after flashing a sd/Usb memory and mounted the bootfs rootfs partitions on a system ( I use linux mint but I think every linux distribution should be ok), this shell will change the content of /boot/config,txt in order to resize the video dimension when working with HDMI, insert two commented lines  to disable WiFi and Bluetooth, then it will create for the PI user some directory where it copies some configurations files for Terminal, Geany, Pcmanfm.
It will create a Shell directory and copy the other shell I wrote : ConfigNewSystem.sh

2) ConfigNewSystem.sh
After the raspberry Pi has booted up with the new created sd/Usb memory open a Terminal and launch this shell , it will install some (for me) useful packages : mc , qbittorrent, amule, gparted, firefox-esr, default-jdk, nemo,  nfs-kernel-server. than it will add two lines to the file /etc/exports, whic rapresent my NFS shares.
this shell will log all the operations in a log file , created where the shell is located. 
