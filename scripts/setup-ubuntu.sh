#!/bin/bash

# Setup Ubuntu intended to be called from curl

# Simple prereqs
sudo apt update
sudo apt upgrade -y
sudo apt install git ansible sshpass -y

# Purge crap that gets in our way
# None yet

# Grab the repo
REPO=https://github.com/jocosocial/server-config
REPO_DIR=/opt/server-config

if [[ -d ${REPO_DIR} && -w ${REPO_DIR} ]]; then
    cd ${REPO_DIR}
    git pull
else
    sudo mkdir -p ${REPO_DIR}
    sudo -E chown ${USER} ${REPO_DIR}
    git clone ${REPO} ${REPO_DIR}
    cd ${REPO_DIR}
fi

# Install required Ansible collections for this repo
ANSIBLE_COLLECTIONS_PATHS=${REPO_DIR}/collections \
    ansible-galaxy collection install -r requirements.yml

#bash scripts/preflight-checks.sh
echo "Skipping preflight checks because I don't support them yet."

# Add localhost to known hosts (idempotent)
mkdir -p ~/.ssh
ssh-keygen -F localhost >/dev/null 2>&1 || ssh-keyscan -H localhost >> ~/.ssh/known_hosts

if [ $? != 0 ]; then
    echo "ERROR: You have some issues to address before you can build your system."
    echo "       See the results of the pre-flight tests above to help in"
    echo "       determining what went wrong."
    exit 1
else
    echo "SUCCESS: You're all set!"
    echo ""
    echo "The workstation repo is at ${REPO_DIR}. An example run would be:"
    echo "  ansible-playbook -kK --ask-vault-pass -l localhost playbooks/server.yaml"
    echo ""
fi
