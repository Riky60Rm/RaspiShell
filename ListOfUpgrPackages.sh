#!/bin/bash

# v2023.06.16 - First created
# Riccardo Cigola <rcigola@gmail.com>
#
# Read the read.md for the funcionality of the program-

# Define a function
function pressKey() {
    echo 'press a key to continue or Ctrl-c to exit'
    read  READV01
}

function Purpose() {
    clear
    echo ' this shell will check for a new version of packages avaliable '
    echo ' and it will install them except for the package realvnc-vnc-server'
    echo ' which actually does not connect to Remmina vnc client'
    echo ' List of upgradable packages :'
    while read -r line; do
      echo "-> $line"
    done <<< "$output"        
    pressKey
}

function createFile() {
    currentDateTime=$(date '+%Y-%m-%d_%H-%M-%S')
    fileName="ListOfUpgrPackages.$currentDateTime.log"
    echo "Creating file: $fileName"
    touch "$fileName"
}

function pkgList() {
    output="" 
    # Run the command and store the output in a variable
    output=$(apt list --upgradable 2>/dev/null)
    # echo "output = $output " 
    if [[ $output = "Listing..." ]]; then
      echo " "
      echo "There is no package to upgrade " 
      echo " "
      pressKey
      exit 0
    fi  

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
pkgList
Purpose
createFile

# Loop through each line of the output
while read -r line; do
  # Use regular expressions to test if the line contains the package name
  if [[ $line =~ ^realvnc-vnc-serverzz/ ]]; then
#  if [[ $line =~ ^realvnc-vnc-server/ ]]; then
    writeFile "NOT upgr $line" "bold"
  elif [[ $line =~ ^Listing\.\.\.$ ]]; then
    continue 
  else 
    pkgName=$(echo "$line" | cut -d'/' -f1)
    writeFile "upgr -> $pkgName"
    writeFile "sudo apt-get install -y $pkgName"
    sudo apt-get install -y $pkgName
    return_code=$?
    # Test the return code and print a message
    if [[ $return_code -ne 0 ]]; then
      writeFile "The command failed with return code $return_code"
    else
      writeFile "The command succeeded"
    fi
    echo "  "
  fi
done <<< "$output"

# Define the tar archive file and the file you want to check
tar_file="ListOfUpgrPackages.tar"

# put new log file in a tar file
tar -rf ListOfUpgrPackages.tar $fileName

# Use tar to list the contents of the archive and grep to search for the file
if tar tf "$tar_file" | grep -q "$fileName"; then
    echo "$fileName added to $tar_file."
    rm $fileName 
    echo "$fileName deleted"
else
    echo "$fileName does not exist in $tar_file."
    echo "$fileName not deleted" 
fi

writeFile " end of shell execution "

pressKey
