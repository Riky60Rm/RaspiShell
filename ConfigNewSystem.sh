#!/bin/bash

# Define a function
function pressKey() {
    echo 'press a key to continue or Ctrl-c to exit'
    read  READV01
}
# List of packages to install
packages=(
  mc
  qbittorrent
  amule
  gparted
  firefox-esr
  default-jdk
  nfs-kernel-server
)

function Purpose() {
    clear
    echo "Run on a just flashed Raspberry pi OS, it will install the following packages :"
    for package in "${packages[@]}"; do
      echo "    $package "
    done
    pressKey
}

function createFile() {
    currentDateTime=$(date '+%Y-%m-%d_%H-%M-%S')
    fileName="ConfigNewSystem.$currentDateTime.txt"
    echo "Creating file: $fileName"
    touch "$fileName"
}

function writeFile() {
    local param1="$1"
    local param2="$2"
    if [[ "$param2" = "bold" ]]; then
        echo "------------------------------------------------" >> $fileName 
        echo "$param1"
        echo "$param1" >> $fileName   
        echo "------------------------------------------------" >> $fileName 
    else
        echo "$param1"
        echo "$param1" >> $fileName   
    fi
}


Purpose

createFile

pressKey

sudo apt update

# Loop over packages
for package in "${packages[@]}"; do
  writeFile "# ----------------------------------"
  writeFile "Installing package: $package"
    writeFile "# ----------------------------------"
  # Install package
  sudo apt-get install -y "$package"
  
  # Check return code
  if [ $? -eq 0 ]; then
    writeFile "Package $package installed successfully"
  else
    writeFile "Failed to install package $package   rc = $?" "bold"
    exit 32
  fi
done

filetxt="/etc/exports"
# check for config.txt
if [ -f "$filetxt" ]; then
    writeFile "File $filetxt exists"
    # insert two lines for NFS share
    echo "# /media/pi/500Gb *(rw,sync,fsid=0,no_subtree_check,insecure)" | sudo tee -a $filetxt
    echo "/media/pi/500Gb *(rw,no_root_squash,subtree_check,fsid=0)" | sudo tee -a $filetxt
    writeFile "line written on file $filetxt"

else
    writeFile "File $filetxt does not exist" "bold"
    pressKey
    exit 32
fi

pressKey




















