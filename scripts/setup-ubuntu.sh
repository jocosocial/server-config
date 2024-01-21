#!/bin/bash

# Setup Ubuntu intended to be called from curl

# Simple prereqs
sudo apt update
sudo apt upgrade -y
sudo apt install git -y
# https://github.com/jocosocial/twitarr-prod/issues/50
sudo pip3 install ansible -y

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

#bash scripts/preflight-checks.sh
echo "Skipping preflight checks because I don't support them yet."

if [ $? != 0 ]; then
    echo "ERROR: You have some issues to address before you can build your system."
    echo "       See the results of the pre-flight tests above to help in"
    echo "       determining what went wrong."
    exit 1
else
    echo "SUCCESS: You're all set!"
    echo ""
    echo "The workstation repo is at ${REPO_DIR}. An example run would be:"
    echo "  ansible-playbook -K --ask-vault-pass -l localhost playbooks/server.yaml"
    echo ""
fi
