#!/bin/bash
exec sudo -u postgres /usr/lib/postgresql/9.3/bin/postgres -D /var/datadrive/postgresql -c config_file=/etc/postgresql/9.3/main/postgresql.conf
