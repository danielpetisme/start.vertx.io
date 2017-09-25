#!/bin/sh

private_key_file=
user=
ansible-playbook -v --private-key=${private_key_file} --user=${user} -i hosts site.yml