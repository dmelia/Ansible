#!/bin/bash

echo "Push an existant repository"
echo "What is the orign repository name ?, exemple: https://github.com/geds3169/Ansible.git :"
read name

git remote add origin "$name"
git branch -M main
git push -u origin main