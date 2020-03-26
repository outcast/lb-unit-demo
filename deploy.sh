#!/usr/bin/env bash

#Deploy Origin Server
pushd ./terraform
make plan
make apply
popd
echo Sleeping so servers can boot....
sleep 20
ansible-playbook -e "ansible_user=root" -i ./configs/ansible/nodes.conf ./playbooks/*-node.playbook
