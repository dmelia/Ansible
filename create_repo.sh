#!/bin/bash

echo "# Ansible" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/geds3169/Ansible.git
git push -u origin main