#!/bin/bash
set -e

echo "Initializing PostgreSQL datadrive and PostGIS extension..."
mkdir -p /var/datadrive/postgresql
chmod -R 700 /var/datadrive/postgresql
chown -R postgres:postgres /var/datadrive/postgresql
sudo -u postgres /usr/lib/postgresql/9.3/bin/initdb -D /var/datadrive/postgresql
sed 's,/var/lib/postgresql/9.3/main,/var/datadrive/postgresql,g' /etc/postgresql/9.3/main/postgresql.conf > tmpfile && mv tmpfile /etc/postgresql/9.3/main/postgresql.conf

POSTGRESQL_BIN=/usr/lib/postgresql/9.3/bin/postgres
POSTGRESQL_CONFIG_FILE=/etc/postgresql/9.3/main/postgresql.conf
POSTGRESQL_SINGLE="sudo -u postgres $POSTGRESQL_BIN --single --config-file=$POSTGRESQL_CONFIG_FILE"

echo "Creating admin user and extensions..."
$POSTGRESQL_SINGLE <<< "CREATE ROLE admin WITH LOGIN SUPERUSER CREATEDB CREATEROLE PASSWORD 'admin';" > /dev/null
$POSTGRESQL_SINGLE <<< "CREATE EXTENSION postgis;" > /dev/null
$POSTGRESQL_SINGLE <<< "CREATE EXTENSION postgis_topology;" > /dev/null
$POSTGRESQL_SINGLE <<< 'CREATE EXTENSION "uuid-ossp";' > /dev/null

echo "Starting postgres..."
exec sudo -u postgres $POSTGRESQL_BIN --config-file=$POSTGRESQL_CONFIG_FILE

echo "Importing dataset..."
/docker/src/scripts/postgres.build.sh
