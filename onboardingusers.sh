#!/bin/bash

# This script is written to automate adding new user on a linux server.
# The script will also check if the user exists before creating it.
# The script will read in usernames from a CSV file named users.csv

username=$(cat users.csv)

# Ensuring root user access?
if [ $(id -u) -eq 0 ]; then

# Reading the CSV file
	for name in $username; do
        	echo $name
        	if id "$name" &>/dev/null
        	then
            		echo "user exist"
        	else
# create the user
        	useradd -m -d /home/$name -s /bin/bash -g developers $name
        	echo "Creating user account"
        	echo

# Create a ssh folder in user home folder
        	su - -c "mkdir ~/.ssh" $name
        	echo "creating .ssh directory"
        	echo

# changing user permission on the .ssh directory
         	su - -c "chmod 700 ~/.ssh" $name
         	echo "Setting user permission for .ssh directory"
         	echo

# Create an authorized-keys file
        	su - -c "touch ~/.ssh/authorized_keys" $name
        	echo "Creating authorized_keys file"
        	echo

# Setting permission for the authorized_keys file
        	su - -c "chmod 600 ~/.ssh/authorized_keys" $name
        	echo "Setting user permission for the authorized-keys file"
        	echo

# Creating and setting public key for users
        	cp -R "/home/adeleye/.ssh/id_rsa.pub" "/home/$name/.ssh/authorized_keys"
        	echo "Copying public key to use account"
        	echo

# Change owner on the authorized key file
        	sudo chown $name /home/$name/.ssh/authorized_keys
        	echo "Complete"
        	fi
	done
else
	echo "Only root may add a user to the system"
fi