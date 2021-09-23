###########################################
#
# geds3169
# guilhem.schlosser@outlook.com
#
# This script create the wole tree
# for a job (role) in the Ansible
# directory & the default yaml file will be
# created inside but empty :)
#
# 23/09/2021
#
#########################################

#!/bin/bash

#vars
path="/etc/ansible"
fullpath="/etc/ansible/roles"

# update system
#sudo apt update && apt upgrade -y

# Install tree package
apt install tree

# go to ansible folder
cd $path

# create roles folder for all job ansible if not exist
if [[ ! -e $fullpath ]]; then
        echo "the roles directory does not exist and the directory will be created"
    mkdir $fullpath
elif [[ ! -d $fullpath ]]; then
    echo "$fullpath already exists, the tree will be deployed" 1>&2
fi


echo "Enter the name of the role for which the tree will be deployed, followed by [enter]:"
read role

# check first if the job exist inside roles
if [[ ! -e $fullpath ]]; then
        echo "the $role directory does not exist in $fullpath and the directory will be created"
    mkdir $fullpath
elif [[ ! -d $fullpath ]]; then
    echo "$role already exists, the tree will be deployed" 1>&2
fi

# create directory and subdirectory
mkdir -p $fullpath/$role/{defaults,files,handlers,meta,tasks,templates,vars,tests/inventory}


echo "The whole tree has been created"


touch /etc/ansible/roles/"$role"/defaults/main.yml
touch /etc/ansible/roles/"$role"/handlers/main.yml
touch /etc/ansible/roles/"$role"/meta/main.yml
touch /etc/ansible/roles/"$role"/README.md
touch /etc/ansible/roles/"$role"/tasks/main.yml
touch /etc/ansible/roles/"$role"/tests/test.yml
touch /etc/ansible/roles/"$role"/vars/main.yml



echo "check structure"
# check structure
sudo tree -a $fullpath/$role


# Explaination
echo "-> files: all the files to copy to the node"
echo "-> templates: all Jinja template files"
echo "-> tasks: list of instructions to be executed (the main.yml file is mandatory)"
echo "-> handlers: even chosen for handlers instructions (the main.yml file is mandatory)"
echo "-> vars: file containing variable declarations (the main.yml file is mandatory); the variables defined here have priority over the variables defined in the inventory"
echo "-> defaults: default values ​​(main.yml file is mandatory) with lower priority"
echo "-> meta: role dependencies and information (author, license, platforms, etc.) on the role (the main.yml file is required)"
echo "."
echo "..n"
echo "...End of the task, have a nice day..."

exit 1
