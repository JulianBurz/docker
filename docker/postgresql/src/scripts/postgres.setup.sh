#!/bin/bash
set -e

echo "Initializing PostgreSQL datadrive..."
mkdir -p /var/datadrive/postgresql
chmod -R 700 /var/datadrive/postgresql
chown -R postgres:postgres /var/datadrive/postgresql
sudo -u postgres /usr/lib/postgresql/9.3/bin/initdb -D /var/datadrive/postgresql
sed 's,/var/lib/postgresql/9.3/main,/var/datadrive/postgresql,g' /etc/postgresql/9.3/main/postgresql.conf > tmpfile && mv tmpfile /etc/postgresql/9.3/main/postgresql.conf

