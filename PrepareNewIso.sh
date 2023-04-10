#!/bin/bash

# Define a function
function pressKey() {
    echo 'press a key to continue or Ctrl-c to exit'
    read  READV01
}

function Purpose() {
    clear
    echo "----------------------- Raspberry pi OS --------------------------------"
    echo "This shell will modify config.txt of fresh flashed SD or USB memory to let HDMI video"
    echo "within the border of the screen "
    echo "It will also add the lines for disabling bluetooth and wifi "
    echo "it will create the /user/pi/Shell directory and copy the shell ConfigNewSystem.sh"
    echo "it will copy the configuration files for the programs: "  
    echo "Terminal, Geany, PcManFm   for the Pi user. " 
    echo " " 
    echo "It needs Zenity to be installed to work" 
    echo " "     
    pressKey
}

Purpose

# check if zenity is installed 
if which zenity >/dev/null; then
    echo "zenity is installed"
else
    echo "this shell require zenity to be executed"
    exit 32
fi

# file picker
# filename=$(zenity --file-selection --title="Select a file")

# directory picker
directory=$(zenity --file-selection --directory --title="Select the bootfs directory")

filetxt=$directory/config.txt
# check for config.txt
if [ -f "$filetxt" ]; then
    echo "File $filetxt exists"
else
    echo "File $filetxt does not exist"
    pressKey
    exit 32
fi

# remove the comment on screen margin lines
sed -i -e '/^#overscan_left=16$/ s/#//' -e '/^#overscan_right=16$/ s/#//' "$filetxt"
retcode1=$?
sed -i -e '/^#overscan_top=16$/ s/#//' -e '/^#overscan_bottom=16$/ s/#//' "$filetxt"
retcode=$?

# remove the cooment for the screen lines
if [[ "$retcode" -eq 0 && "$retcode1" -eq 0 ]]; then
    echo "sed uncommented the lines of border screen "
else
    echo "error on sed uncomment the lines of border screen "
    pressKey
    exit 32
fi

# set the right screen margin
sed -i 's/left=16/left=60/g; s/right=16/right=60/g; s/top=16/top=26/g; s/bottom=16/bottom=26/g' "$filetxt"
retcode=$?
if [ "$retcode" -eq 0 ]; then
    echo "sed changes of border screen successfully executed (left=16 --> left=60)"
    #echo " retcode = $retcode    retcode1 = $retcode1 "
else
    echo "error on sed changes of border screen"
    #echo " retcode = $retcode    retcode1 = $retcode1 "
    pressKey    
    exit 32
fi

# insert two lines for bluetooth and wifi
sed -i '/overscan_bottom/a\
#\
# disable wi-fi\
# dtoverlay=disable-wifi\
#\
# disable bluetooth\
# dtoverlay=disable-bt\
' $filetxt
retcode=$?
if [ "$retcode" -eq 0 ]; then
    echo "sed insert lines for bluetooth and wifi successfully executed"
else
    echo "error on sed insert lines for bluetooth and wifi"
    exit 32
fi

# directory picker
directory=$(zenity --file-selection --directory --title="Select the rootfs directory")

rootdir="$directory"/home/pi
cd $rootdir
retcode=$?
if [ "$retcode" -eq 0 ]; then
    echo "successfully changed to directory $rootdir"
else
    echo "error couldn't change to $rootdir directory"
    exit 32
fi
# -------------------------------------------------------------------------------------
mkdir Shell
retcode=$?
if [ "$retcode" -eq 0 ]; then
    echo "$rootdir/Shell created sucessfully"
    cp /home/riky60/Shell/ConfigNewSystem.sh $rootdir/Shell
else
    echo "error couldn't create $rootdir/Shell"
    exit 32
fi
# -------------------------------------------------------------------------------------
mkdir .config
retcode=$?
if [ "$retcode" -eq 0 ]; then
    echo "$rootdir/.config created sucessfully"
else
    echo "error couldn't create $rootdir/.config"
    exit 32
fi
# -------------------------------------------------------------------------------------
fromdir="/media/riky60/12Tb/LinuxIso/Raspian/ConfigFile"
mkdir .config/lxterminal
retcode=$?
if [ "$retcode" -eq 0 ]; then
    echo "$rootdir/.config/lxterminal created sucessfully"
    cp $fromdir/lxterminal.conf $rootdir/.config/lxterminal
else
    echo "error couldn't create $rootdir/.config/lxterminal"
    exit 32
fi
# -------------------------------------------------------------------------------------
mkdir .config/geany
retcode=$?
if [ "$retcode" -eq 0 ]; then
    echo "$rootdir/.config/geany created sucessfully"
    cp $fromdir/geany.conf $rootdir/.config/geany
else
    echo "error couldn't create $rootdir/.config/geany"
    exit 32
fi

# --------------------------------------------------------------------------------------
mkdir .config/pcmanfm
mkdir .config/pcmanfm/pcmanfm
mkdir .config/pcmanfm/pcmanfm/LXDE-pi
dirto=".config/pcmanfm/pcmanfm/LXDE-pi"
retcode=$?
if [ "$retcode" -eq 0 ]; then
    echo "$rootdir/.config/pcmanfm/pcmanfm/LXDE-pi created sucessfully"
    cp $fromdir/pcmanfm.conf $rootdir/$dirto
else
    echo "error couldn't create $rootdir/.config/pcmanfm/pcmanfm/LXDE-pi"
    exit 32
fi





pressKey









