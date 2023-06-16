#!/bin/bash

# v2023.06.16 - First created
# Riccardo Cigola <rcigola@gmail.com>
#
# Add a user to be used as vncuser when I connect to Raspberry thru VNC  


# Define a function
function pressKey() {
    echo 'press a key to continue or Ctrl-c to exit'
    read  READV01
}

function purpose() {
    clear
    echo "------------------------ Raspberry pi OS -----------------------------"
    echo "Add a VNCuser to allow remote connection to the system"
    pressKey
}

function writeFile() {
    local param1="$1"
    local param2="$2"
    if [[ "$param2" = "bold" ]]; then
        echo "------------------------------------------------" 
        echo "$param1"
        echo "------------------------------------------------" 
    else
        echo "$param1"
    fi
}


purpose

user="vncuser"
sudo useradd -s /bin/bash -m $user
if [ $? -eq 0 ]; then
 writeFile "User for VNC connection $user created" 
else
 writeFile "User $user not created"
 exit 32
fi 
# ----------------- set user pssw
echo "$user:$user" | sudo chpasswd 
if [ $? -eq 0 ]; then
 writeFile "password for user $user created" 
else
 writeFile "error on setting password for user $user - rc = $?"
 exit 32
fi 

pressKey
