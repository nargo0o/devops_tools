#!/bin/bash

ansible-playbook ansible/jenkins.yml;
ansible-playbook ansible/provision.yml
