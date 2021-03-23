#!/usr/bin/env bash

if [[ -z $1 ]]; then
	echo "Usage: bash bantuan.sh <username>"	
	echo "Make sure ssh/username>.pub exists as the pubkey"
	echo "and run as root ofc"
else
	usersList="$(awk -F: '{ print $1}' /etc/passwd | grep $1)"
	if [[ "$usersList" =~ ^"$1"$ ]]; then
		echo "$1 already a user"
		exit -1
	fi
	mkdir -p ssh
	if [[ ! -f ssh/$1.pub ]]; then
		echo "ssh/$1.pub not found!"
		exit -1
	fi
	pubKey="$(cat ssh/$1.pub)"
	echo $pubKey
	read -p "Are you sure adding this pubkey to $1 (y/n)? " -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	    # do dangerous stuff
		if [ "$EUID" -ne 0 ]
		  then echo "Please run as root"
		    exit
		fi
		useradd $1
		echo "Making directory /home/$1/.ssh, initializing new user"
		mkdir -p /home/$1/.ssh
		touch /home/$1/.ssh/authorized_keys
		cat "ssh/$1.pub" > /home/$1/.ssh/authorized_keys
		chown -R $1:$1 /home/$1/.ssh
		chmod 700 /home/$1/.ssh
		chmod 644 /home/$1/.ssh/authorized_keys
		echo "OK you must restart the service!" 
	else
		echo "exiting..."
	fi
fi

