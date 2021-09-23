 ----------------------------------------------------------------------------------------------
 # Basic tutorial
  ----------------------------------------------------------------------------------------------
Installing Ansible 2.6 on Ubuntu Bionic Beaver

1 . Connect to your server using SSH:

ssh root@SERVER_IP

If you do not know your server IP, you can list your existing servers using scw ps (Scaleway CLI). For more information on the Scaleway CLI, refer to the tutorial on the Scaleway Command Line Interface.

The server IP can also be retrieved from the Scaleway Console. Once logged in, check the IP Adresses in the Servers tab of the left menu.

    Note: If you use the root user, you can remove the sudo before each command.

2 . Update Ubuntu packet manager:

sudo apt-get update

3 . Upgrade the Ubuntu packages already installed:

sudo apt-get upgrade

Installing Ansible from PPA repository

1 . Update your package index and install the software-properties-common package. This software will make it easier to manage this and other independent software repositories. Add the Ansible PPA and refresh your system’s package index once again.

apt install software-properties-common
apt-add-repository ppa:ansible/ansible
apt update

2 . Install the Ansible software

apt install ansible

3 . Check that the installation is successful

ansible --version

which returns

ansible 2.6.1
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.15rc1 (default, Apr 15 2018, 21:51:34) [GCC 7.3.0]

Alternative Installation of Ansible

To learn more about different methods for installing Ansible, refer to the official Ansible Documentation.
Configuring SSH Access to the Ansible Hosts

1 . Generate a ssh key

ssh-keygen -t rsa

which returns

Enter file in which to save the key (/home/user/.ssh/id_rsa):

it is recommended to press Enter to generate and store the ssh key to the default location.

Enter passphrase (empty for no passphrase):
Enter same passphrase again:

2 . (OPTIONAL) To avoid the prompt of your passphrase, launch exec ssh-agent $SHELL to run a ssh agent, and ssh-add ~/.ssh/id_rsa to add your key to the ssh agent.

3 . Use the cat command to print the contents of your non-root user’s SSH public key file to the terminal’s output

cat ~/.ssh/id_rsa.pub

4 . Copy the resulting output to your clipboard, then open a new terminal and connect to one of your Ansible hosts using SSH

ssh root@ansible_host_ip

5 . Open the authorized_keys within the ~/.ssh directory

nano ~/.ssh/authorized_keys

6 . In the file, paste your Ansible server user’s SSH key, then save the file and close the editor.

7 . Install Python 3 on the host in order for Ansible to communicate with it.

    Note: Python 2 is almost at its EOF and Ubuntu Bionic Beaver does not integrate version 3 by default.

apt update
apt install python3

8 . To make Ansbile wirking with Python 3, specify the Python interpreter in a var or in the inventory.

 - hosts: all
  vars:
    ansible_python_interpreter: /usr/bin/env python3

host1 ansible_ssh_host=X.X.X.X ansible_python_interpreter=/usr/bin/env python3

9 . IMPORTANT: Under Credentials Paste your SSH key in the Scaleway Console and click Use this SSH Key

10 . Run the exit command to close the connection to the client

Repeat this process for each server you intend to control with your Ansible server. Next, we’ll configure the Ansible server to connect to these hosts using Ansible’s hosts file.
Configuring Ansible Hosts

1 . Ansible tracks of all of the servers through an inventory file. We need to set up this file first before we can communicate with our other computers.

On your Ansible server, open the file

sudo nano /etc/ansible/hosts

In our example, we have two servers controlled with Ansible. The hosts file is fairly flexible and can be configured in a few different ways. The syntax we are going to use, though, looks like this:

[group_name]
alias ansible_ssh_host=your_server_ip

In this example, group_name is an organizational tag that lets you refer to any servers listed under it with one word, while alias is just a name to refer to one specific server. For the tutorial purpose, our host file looks like this:

[servers]
host1 ansible_ssh_host=X.X.X.X
host2 ansible_ssh_host=X.X.X.X

2 . Save and close this file when you are finished.

If you want to specify configuration details for every server, regardless of group association, you can put those details in a file at /etc/ansible/group_vars/all. Individual hosts can be configured by creating files named after their alias under a directory at /etc/ansible/host_vars.



Using Ansible Commands:
                        Ping all of the servers:
                                                ansible -m ping all
                                                
                        specify a group:
                                                ansible -m ping servers
                                                 
                        specify an individual host:
                                                ansible -m ping host1
                         
                        ansible-playbook:
                                          [role name].yml --ask-sudo-pass
 
 Additionally, you can configure the default path where Ansible roles will be downloaded by editing your ansible.cfg configuration file
 (normally located in /etc/ansible/ansible.cfg and setting a roles_path in the [defaults] section.
 
 ----------------------------------------------------------------------------------------------
 # Tools
 ----------------------------------------------------------------------------------------------

 Atom Text Editor is a cross-platform free text editor developed in NodeJS by GitHub. The first version was released in April 2014 but it already has a huge plugin library1). It is based on Chromium and is extremely customizable. It can also be used as an idea.

Atom supports most programming languages, including Python, Javascript, Bash, Ruby, Perl, C, C ++, Java, and many more.

__ ! NEED A GUI INTERFACE ! __

                           Download ATOM Editor: https://github.com/atom/atom/releases use wget https://github.com/atom/atom/releases/download/v1.59.0-beta0/atom-amd64.deb
                                        Install: sudo dpkg -i atom-amd64.deb
                           or
                           install from package (depends on the distribution):  sudo apt-get install atom
 
  ----------------------------------------------------------------------------------------------
 # Scripts
 ----------------------------------------------------------------------------------------------
 
 * __builds_the_role_tree.sh__
 
    built the role tree and created the default YAML files - but blank :)
    
    ![image](https://user-images.githubusercontent.com/28867314/134551387-4e1f92ae-6104-4309-9a6d-81c4e2623570.png)

 
  ----------------------------------------------------------------------------------------------
  
  * __vault_generator.sh__
  
    Allows you to generate a file containing the user login and password, in order to call them in a variable
  
