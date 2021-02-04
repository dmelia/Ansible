#!/bin/bash

echo "This script install git on server"

apt-get update && apt-get upgrade -y

# Install git
apt-get install git-all -y

git --version

echo "git is installed"

echo " Now configure git to your git"

echo " Write your username git"
read username

echo " Write your mail associed to git"
read mail

read -p "Did you want connect to your git with this information?  : y/Y/n/N/cancel" CONDITION;
if [ "$CONDITION" == "y/Y" ]; then
   # do something here!
   git config --global user.name "$username"
   git config --global user.mail "$mail"
fi

echo "loging configured"

git config --list

echo "End of the job"

#The configuration settings are stored in the ~/.gitconfig file

cat ~/.gitconfig

echo "please now insert the following line to the bottom .gitconfig file :"

echo " [alias] 
    ci = commit 
    co = checkout 
    st = status 
    br = branch"

echo "End of the task, Bye"

exit