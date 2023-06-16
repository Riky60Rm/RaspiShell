# RaspiShell
Shell used to customize a fresh flashed Raspberry pi OS 

tired of manual operation to install and configure Raspi OS I wrote four Shells :

1) PrepareNewIso.sh 
which has to be launched after flashing a sd/Usb memory, and after mounting the bootfs rootfs partitions on a system ( I use linux mint but I think every linux distribution should be ok), this shell will change the content of /boot/config,txt in order to resize the video dimension when working with HDMI, insert two commented lines to disable WiFi and Bluetooth, then it will create for the PI user some directory where it copies some configurations files for Terminal, Geany, Pcmanfm. It will create a Shell directory and copy the other shell I wrote : ConfigNewSystem.sh

2) ConfigNewSystem.sh
After the raspberry Pi has booted up with the new created sd/Usb memory open a Terminal and launch this shell , it will install some (for me) useful packages : mc , qbittorrent, amule, gparted, firefox-esr, default-jdk, nemo,  nfs-kernel-server. than it will add two lines to the file /etc/exports, which rapresent my NFS shares.
this shell will log all the operations in a log file , created where the shell is located. 


3) ListOfUpgrPackages.sh 
I use this shell to upgrade the Raspi OS for the new  packages, it will write a log file of the upgradeted packages, if there is no packages to upgrade it will exit .

4) AddVncUser.sh
   add a vncuser user to system, in order to connect thru VNC
