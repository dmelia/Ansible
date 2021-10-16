#!/bin/sh

#####################################################################################
#
# Script by geds3169
# 16/10/2021
#
# generate key ssh and ad some slave servers
#
# 1 step:
# 
# install openssh-server in to the slave
# secure ssh /etc/sshd_config =>
# PermitRootLogin no
# AllowUser user_name (in the host, not the root)
#
#
# 2 step:
# install Ansible, configure, run the basic playbook, ping slave, install tools
#
# Deploy from host the ssh key to the slave, running the playbook authorized_keys.yml
#
#####################################################################################

echo "This script generate ssh rsa key pair in to the host"
echo "Answer the various questions asked"
echo "Utilise ssh-copy-id to deploy the public key to the slaves"
echo "Based on a node consisting of one host and two slaves"
echo "This script must be run as root"

###############################
# Check user running the script
###############################

if [ "$(whoami)" != 'root' ]; then
echo "$Red \n You are not root, This script must be run as root $Color_Off"
exit 1;
fi

###############################
# generate rsa key
###############################
apt install openssh-server -y

###############################
# generate rsa key
###############################
echo "Answer the various questions asked"
ssh -t rsa

###############################
# copy ssh public key to remote server (slave)
# use ssh-copy-ID
###############################

echo "First slave"
echo "Specify the remote user and machine such as:"
echo "user_name@ip or user_name@domain.tld"
read remote_host1

echo "Second slave"
echo "Specify the remote user and machine such as:"
echo "user_name@ip or user_name@domain.tld"
read remote_host2

echo "Don't forget to fill in the password associated with the rsa key and test the connection in to all slave from the host"
ssh-copy-id $remote_host1

ssh-copy-id $remote_host2

###############################
#Verification of proper execution
###############################

echo "Write the name of the ssh key used on slave 1, without the .pub"
read slave1
echo "Write the name of the ssh key used on slave 2, without the .pub"
read slave2

cat ~/.ssh/$slave1 | ssh $remote_host1 'cat >> ~/.ssh/authorized_keys'
cat ~/.ssh/$slave2 | ssh $remote_host2 'cat >> ~/.ssh/authorized_keys'

echo "End of the tasks, have a good day ;)"

exit 0

