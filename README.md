Vagrant and Docker setup for Twine
=======================

Virtual OS: Ubuntu 12.04 (Precise) x64
With Packages:
- Apache
- PHP
- phpPgAdmin
- Curl
- OAuth
- Mongo
- Prince
- Python
- Flask

## Requirements:
- VirtualBox (https://www.virtualbox.org/wiki/Downloads), tested with v4.3.14
- Vagrant (http://downloads.vagrantup.com), tested with v1.6.3

## Guide:  
1. Download and install software from Requirements  
2. Create a folder named 'twineapp/' and clone this repository (twineapp/docker).  
3. Clone / copy in the twine repos and datasets  
    3.1. Clone 'siv-v3' github repository into 'twineapp/docker/docker/web/src/siv-v3/' directory (~55MB)  
    3.2. **(optional)** Clone 'api-data' github repository into 'twineapp/docker/docker/web/src/siv-v3/api-data/' directory (~0.3MB)  
    3.3. **(optional)** Clone 'documentation' github repository into 'twineapp/documentation/' directory  
    3.4. Copy twine postgresql build to 'twineapp/docker/docker/postgresql/src/' directory (~83MB)  
    3.5. **(optional)** Copy twine mongodb build to 'twineapp/docker/docker/mongo/src/' directory (~288MB)
4. Run terminal, go into 'twineapp/docker/', and execute the command 'vagrant up'. This will download the base box of ubuntu (~35MB), and bring up the twine vm  

## Working with the twine vagrant:
- "vagrant up" starts the virtual machine
- "vagrant suspend" suspends the vm, this is normally how you would end your work session
- "vagrant halt" shuts down the vm, you would do this to autoload additional db patches for example
- "vagrant reload" is equivelent to a halt and up, and should be run after changes to the vagrant repo. Before a reload, delete the siv_% dbs (you can run siv.drop.sql in phpmyadmin to do this)
- "vagrant destroy" completely removes the vm from your machine. You would do this to save disk space if you won't be working on twine for a while, or to do a full rebuild after significant changes to the vagrant repo
- command reference: http://docs.vagrantup.com/v2/cli/index.html

## Working with the twine docker:
- "docker ps" shows list of running docker containers
- "docker inspect DOCKER_IMAGE_NAME" shows container details, including local IP

## Notes:
- Server should be ready to use at 192.168.50.5 (modify this static IP in Vagrantfile before bringing up the vagrant if required)
- Test via http://192.168.50.5/phpinfo.php OR http://192.168.50.5/siv-v3/login.php
- this project directory is linked to the webserver document root
- Command to copy files to Amazon EC2: scp -i ~/Desktop/ubuntu.pem sql/\* ubuntu@54.243.48.252:/var/www/docker/src/sql

## PHP Docs:
- To setup phpdoc and dependencies run in the web container: sudo /docker/src/scripts/phpdoc-setup.sh
- To generate autodocs for the Twine API run in the web container: /docker/src/scripts/phpdoc-build.sh
- Docs available at: http://192.168.50.5/siv-v3/docs/
- these are copied into the documentation repo at documentation/api/app/

## VM Passwords
- rockmongo username:password are admin:admin
- postgres username:password are admin:admin
- SSH into any of the docker containers with root:password

## Known issues (ETL NOT YET ADDED)
- **Hardware virtualization.** Issues have been reported in Windows 7 when hardward virtualization was not enabled in the system bios. http://www.virtualbox.org/manual/ch10.html
- **Python install in Windows hosts.** The etl-setup.sh script is not executing in windows hosts. To run in manually:
    - bring up the vagrant
    - ssh in
    - $ cd /var/www/flaskapps/etl/
    - $ sudo python setup.py install
    - in your host, copy twineapp/docker/puppet/templates/config_local.py to twineapp/flaskapps/etl/ETL/config_local.py
    - $ sudo apachectl restart
    - You should now get a response at 192.168.50.5/etl/status

## TODO
- add ETL
- add python