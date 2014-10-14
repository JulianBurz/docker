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

echo "Importing dataset..."
/docker/src/scripts/postgres.build.sh

echo "Creating admin user and extensions..."
sudo -u postgres psql -q -c "CREATE ROLE admin WITH LOGIN SUPERUSER CREATEDB CREATEROLE PASSWORD 'admin';"
sudo -u postgres psql -q -c "CREATE EXTENSION postgis;"
sudo -u postgres psql -q -c "CREATE EXTENSION postgis_topology;"
sudo -u postgres psql -q -c 'CREATE EXTENSION "uuid-ossp";'