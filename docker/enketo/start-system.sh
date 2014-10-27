#!/bin/bash

if [ -f /dont-init-system-build ]; then
    echo "Init system build already ran, exiting"
    exit
else
    touch /dont-init-system-build
fi

BOOTSTRAP_FILE=/docker/src/enketo-express/setup/bootstrap.sh

sed 's,/vagrant,/docker/src/enketo-express,g' $BOOTSTRAP_FILE > tmpfile && mv tmpfile $BOOTSTRAP_FILE
sed 's,stop redis-server,#REMOVED,g' $BOOTSTRAP_FILE > tmpfile && mv tmpfile $BOOTSTRAP_FILE
sed 's,service redis-server-enketo-main start,#REMOVED,g' $BOOTSTRAP_FILE > tmpfile && mv tmpfile $BOOTSTRAP_FILE
sed 's,service redis-server-enketo-cache start,#REMOVED,g' $BOOTSTRAP_FILE > tmpfile && mv tmpfile $BOOTSTRAP_FILE
sed 's,pm2 start app.js -n enketo,#REMOVED,g' $BOOTSTRAP_FILE > tmpfile && mv tmpfile $BOOTSTRAP_FILE

chmod +x $BOOTSTRAP_FILE
$BOOTSTRAP_FILE