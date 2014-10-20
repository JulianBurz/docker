#!/bin/bash

if [ -f /dont-init-system-build ]; then
    echo "Init system build already ran, exiting"
    exit
else
    touch /dont-init-system-build
fi

while [ ! -n "$(pgrep "mongod")" ]; do
echo 'Waiting for mongod to be deployed'
sleep 10
done
sleep 20

export LC_ALL=C

# Import datasets
#mongorestore --drop -d siv /docker/src/his.bson
mongorestore --drop -d siv /docker/src/de_urban.bson > /dont-init-system-build