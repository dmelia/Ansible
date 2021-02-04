#!/bin/bash

echo "What is the name of the repository what do you want to create ? "
read name

echo "echo "# $name" >> README.md

git init
git add "$name"
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:geds3169/Ansible.git
git push -u origin main