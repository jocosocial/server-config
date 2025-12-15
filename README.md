Twitarr Server Config
=====================

All the things needed to make the Twitarr production server.

Prerequisites
-------------
* Ubuntu 24.04 Server

Installation
------------
01. Install some prereqs:
    ```
    sudo apt update
    sudo apt install -y git ansible
    ```

02. Clone this repo onto the server and `cd` to it.

03. From the root of this repo:
    ```
    ansible-playbook playbooks/server.yaml
    ```
