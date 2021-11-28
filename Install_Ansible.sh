#! /bin/bash

#############################################
# This script install ansible in
#
# ubuntu 20.04
#
# guilhemETkarine@hotmail.fr
#
# 26/11/2021
#
##############################################

###############################
# Check user running the script
###############################

if [ "$(whoami)" != 'root' ]; then
echo "$Red \n You are not root, This script must be run as root or sudoer $Color_Off"
exit 1;
fi

########################################
# Custosm Color
########################################
# Color  Variables
green='\e[32m'
blue='\e[34m'
red='\e[31m'
clear='\e[0m'

#########################################
# fonctions
#########################################
ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}

####################
# Advertissment
####################
echo -ne $red "This script has not been tested" $clear

####################
# Update/Upgrade
####################
echo -ne $green "First update and upgrade systeme and packages" $clear
sudo apt update -y && sudo apt ugrade -y

####################
# Active Root Account
####################
echo -ne $green "Enable Root account on the server" $clear
echo -ne $green "1) Write your user password" $clear
echo -ne $green "2) Add new password for Root account, and repeat the operation" $clear
sudo passwd root

########################################
# Generate SSH key pair for current user
########################################
echo -ne $green "Generate key pair for the current user" $clear
echo -ne $green "place the key in the /home/username/.ssh/master_ansible  this is the private key" $clear
echo -ne $green "The public key is generated automaticly in the same time & same location (do not add extension)" $clear
sudo ssh-keygen

echo -ne $green "We change the permission of the pair key" $clear
echo -ne $green "Write the path of the key pair and the name" $clear
echo -ne $green "Like this: /home/username/master_ansible : " $clear
read $pathKey
sudo chmod 400 $pathKey*

########################################
# Install SSHPASS
########################################
echo -ne $green "Install the sshpass utility is designed to run SSH using the keyboard-interactive password authentication mode" $clear
sudo apt-get install sshpass -y

########################################
# Add hosts (nodes) to /etc/hosts
########################################
read -rp "Do you want add host ? [y/n/c] "
[[ ${REPLY,,} =~ ^(c|cancel)$ ]] && { echo "Selected Cancel"; exit 1; }
while [[ ${REPLY,,} =~ ^(y|yes|j|ja|s|si|o|oui)$ ]]; do
			echo -ne $green "Enter the [IP(tabulation) hostname.fqdn (tabultation) hostname]" clear
			echo -ne $green "Like 10.0.0.1	slave1.expemple.com	slave1" clear
       echo -ne $green "Enter the information of the new node." clear
            read NewHost
            sudo sed -i -e '$NewHost' /etc/hosts
            echo "Show if it is correct"
			cat /etc/hosts
done
  (echo "Goodbye!"; break)
fi

########################################
# Copy SSH KEY PUB to node
########################################
read -rp "Do you want copy the ssh key to hosts ? [y/n/c] "
[[ ${REPLY,,} =~ ^(c|cancel)$ ]] && { echo "Selected Cancel"; exit 1; }
while [[ ${REPLY,,} =~ ^(y|yes|j|ja|s|si|o|oui)$ ]]; do
            echo -ne $green "Enter the path of the key.pub" $clear
            read key
			echo "Enter the username@IP of the node"
			read node
            sudo ssh-copy-id -i $path $node
done
  (echo "Goodbye!"; break)
fi


########################################
# Move to directory Ansible
########################################
cd /etc/ansible
echo -ne $green "uncomment the line N°15 and 16, replace the current IP to your IP nodes" $clear
echo -ne $green "use sudo nano /etc/ansible/hosts" $clear

########################################
# Adverstissment
########################################

echo "Remember to add on each node in the / etc / hosts file the Ansible master server such as:"
echo "Like [IP(tabulation) hostname.fqdn (tabultation) hostname]"

echo "Install SSH on nodes with sudo apt-get install openssh-server"
echo "Edit the /etc/ssh/sshd_config and add this at the bottom of the file"
echo "PermitRootLogin no"
echo "AllowUserse username --> username is the account name on Ansible master"
echo "Close file and save, now enable service SSH"
echo "sudo systemctl enable sshd --> if not work do the same command and replace sshd by ssh"

########################################
# Adverstissment
########################################

echo -ne $blue "This test may not work if the previous steps have not been done first." $clear
echo -ne $blue "You just have to run the following command again to test the validity once the ssh is installed on the nodes." $clear
echo -ne $blue "Trying test ping nodes" $clear
echo -ne $blue "Write your username(Like account autorised)" $clear
read Name
ansible all -u $Name --ask-ping -m ping

sudo history -c
sudo history -w
clear

exit 0
