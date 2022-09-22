Guilhem TP-6

**<u>Prèsrequis:</u>**

1 master (Ansible)

2 client (1et 2 )

**<u>Consigne:</u>**

playbook: création d'un container avec l'image Super Mario

Un playbook master qui importe les scripts docker.yml et mario.yml

https://hub.docker.com/r/pengbai/docker-supermario/#!

> docker.yml = Installation de docker sur l'hôte
> 
> Installation du docker repository et installation

Création du groupe docker et ajout de l'utilisateur vagrant au groupe docker

> mario.yml = Création du container à partir de l'image

Création du répertoire de travail:

![](file:///C:/Users/guilh/AppData/Roaming/marktext/images/2022-09-22-09-38-57-image.png?msec=1663832344961)

Création du fichier hosts.yml

```bash
[vagrant@ansible TP_mario]$ cat hosts.yaml
---

# inventory, hosts.yml

all:
  children:
    prod:
      hosts:
        client1:
        client2:
```

Création du fichier prod.yml

```bash
[vagrant@ansible TP_mario]$ cat group_vars/prod.yml
---

# group_vars, client1.yml

ansible_user: vagrant
ansible_sudo_pass: vagrant
ansible_ssh_pass: vagrant
```

Création du fichier client2.yml

```bash
[vagrant@ansible TP_mario]$ cat host_vars/client2.yml
---

# group_vars, client2.yml

ansible_host: 192.168.99.12
```

Création du fichier docker.yml

```bash
[vagrant@ansible TP_mario]$ cat docker.yml
---

# Install docker, docker.yml

- name: Install docker
  hosts: prod
  become: yes
  tasks:
    - name: Add repository Epel
      yum:
        name: epel-release
        state: latest

    - name: Install pip module docker
      pip:
        name: docker
        executable: pip3

    - name: Install docker repository
      yum_repository:
        name: Add repository Docker
        description: Docker repo
        file: docker-ce
        baseurl: https://download.docker.com/linux/centos/docker-ce.repo
        enabled: '1'
        gpgcheck: no
        gpgkey: 'https://download.docker.com/linux/centos/gpg'
        state: present

    - name: Install Docker binary
      yum:
        name: docker
        state: latest

    - name: "Start Docker"
      service:
        name: docker
        state: started
        enabled: yes

      group:
        name: docker
        state: present
        system: yes

    - name: Add vagrant to docker group
      user:
        name: vagrant
        groups: docker
        append: yes

    - name: Add rule firewalld
      firewalld:
        port: 8600/tcp
        permanent: yes
        state: enabled
```

Création du fichier mario.yml

```bash
[vagrant@ansible TP_mario]$ cat mario.yml
---

# Deploy container, mario.yml

- name: "Deployment Containers"
  hosts: prod
  become: yes
  vars:
    ansible_python_interpreter: /usr/bin/python3
  tasks:
    - name: Deploy Super Mario container
      docker_container:
        image: pengbai/docker-supermario
        name: docker-supermario
        published_ports: "0.0.0.0:8600:8080"
        network_mode: bridge
        state: started
        #auto_remove: true # Enable auto-removal of the container on daemon side when the container's process exits.

```

Création du fichier deploy_mario.yml

```bash
[vagrant@ansible TP_mario]$ cat deploy_mario.yml
---

# master file, import antoher playbooks, deploy_mario.yml

- import_playbook: docker.yml
- import_playbook: mario.yml

- name: Deploy Docker and Super Mario Container
  hosts: prod
```

Lancement du playbook

```bash
[vagrant@ansible TP_mario]$ ansible-playbook -i hosts.yaml deploy_mario.yml
```

Vérification (un seul client était en état de fonctionnement, sinon tester aussi avec le second client en remplaçant l'ip)

```html
http://192.168.99.10:86000
```
