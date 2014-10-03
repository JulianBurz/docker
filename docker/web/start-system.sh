#!/bin/bash

if [ -f /dont-init-system-build ]; then
    echo "Init system build already ran, exiting"
    exit
else
    touch /dont-init-system-build
fi

while [ ! -f /var/www/siv-v3/index.php ]; do
echo 'Waiting for siv-v3 directory to be deployed'
sleep 10
done
sleep 10

cp /docker/templates/siv.ini /var/www/siv-v3/siv.ini
cp /docker/templates/config.json /var/www/siv-v3/app/config.json

# Setup filestore
mkdir -p /var/www/siv-v3/filestore
chmod 777 /var/www/siv-v3/filestore

# Setup various log files
mkdir /var/www/logs
touch /var/www/logs/etl.log
chmod 777 /var/www/logs/etl.log 
touch /var/www/siv-v3/api-data/twine/scheduler.log
chmod 777 /var/www/siv-v3/api-data/twine/scheduler.log

# Setup Grunt
RUN /docker/src/scripts/grunt-setup.sh

# Setup Twine Instance
mkdir -p /var/www/twine_instances
git clone https://github.com/webhis/instance-who.git /var/www/twine_instances/instance-who
cd /var/www/siv-v3/
grunt dev --instance=/var/www/twine_instances/instance-who
