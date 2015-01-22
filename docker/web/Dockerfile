FROM ubuntu:14.04

# Add files to docker container
ADD ./ /docker/
RUN chmod 755 /docker/*.sh

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install ssh sudo supervisor openssh-server git apache2 libapache2-mod-wsgi libapache2-mod-php5 curl php5 php5-curl php5-cli php-pear php5-dev php-apc php5-gd php5-pgsql phppgadmin make build-essential libpcre3-dev libtiff5 libgif4 python-software-properties software-properties-common python python-pip python-dev libpq-dev

# Add repo with latest nodejs
RUN add-apt-repository -y ppa:chris-lea/node.js

# Install latest nodejs
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install nodejs

# Apache setup
RUN a2enmod rewrite
RUN a2enmod wsgi
RUN echo "ServerName localhost" | sudo tee /etc/apache2/conf.d/fqdn

# Install Mongo extension
RUN pecl install mongo
RUN echo "extension=mongo.so" >> /etc/php5/apache2/php.ini

# Install OAuth
RUN pecl install oauth
RUN echo "extension=oauth.so" >> /etc/php5/apache2/php.ini

# Install Prince
RUN wget http://www.princexml.com/download/prince_9.0-5_ubuntu14.04_amd64.deb -O /tmp/prince_9.0-5_ubuntu14.04_amd64.deb
RUN dpkg -i /tmp/prince_9.0-5_ubuntu14.04_amd64.deb

# Add image config
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf
ADD supervisord-system.conf /etc/supervisor/conf.d/supervisord-system.conf
ADD templates/index.html /var/www/index.html
ADD templates/phpinfo.php /var/www/phpinfo.php
ADD templates/vhost /etc/apache2/sites-available/000-default.conf
ADD templates/TwineHeadlessBrowser /home/TwineHeadlessBrowser

# Setup Twine tools
RUN ln -sf /docker/src/scripts/twine-tools /usr/bin/twine-tools

# Setup phpPgAdmin
RUN sed 's,allow from 127.0.0.0/255.0.0.0 ::1/128,allow from all,g' /etc/apache2/conf.d/phppgadmin > tmpfile && mv tmpfile /etc/apache2/conf.d/phppgadmin
RUN sed "s,'localhost';,'postgresql';,g" /etc/phppgadmin/config.inc.php > tmpfile && mv tmpfile /etc/phppgadmin/config.inc.php

# Install latest pip
RUN easy_install -U pip

# Setup ETL
RUN pip install --upgrade flask
RUN pip install --upgrade pymongo
RUN pip install --upgrade apscheduler==2.1.2
RUN pip install --upgrade pandas
RUN pip install --upgrade isoweek
RUN pip install --upgrade psycopg2

# Setup api-data requirements
RUN pip install -r /docker/src/siv-v3/api-data/requirements.txt

# SSHD config
RUN mkdir /var/run/sshd
RUN echo "root:password" | chpasswd

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22 80

#RUN /docker/run.sh # This casues "docker build" to never exit/ complete execution
CMD ["/usr/bin/supervisord"] 

# Test with url below in browser
#http://192.168.50.5/ or http://localhost/