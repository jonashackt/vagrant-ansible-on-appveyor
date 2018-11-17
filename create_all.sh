#!/usr/bin/env bash
set -euo pipefail

vagrant up
#vagrant dns --install
ansible-playbook playbook.yml -i hosts
