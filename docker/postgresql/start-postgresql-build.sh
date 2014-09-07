#!/bin/bash

if [ -f /dont-init-postgres-build ]; then
    echo "Init postgres build already ran, exiting"
    exit
else
    touch /dont-init-postgres-build
fi

while [ ! -f /var/datadrive/postgresql/postmaster.pid ]; do
echo 'Waiting for PostgreSQL to come online'
sleep 10
done
sleep 10

/docker/src/scripts/postgres.build.sh