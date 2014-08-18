FROM ubuntu:12.04

# Add files to docker container
ADD ./ /docker/
RUN chmod 755 /docker/*.sh

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install ssh sudo supervisor git apache2 libapache2-mod-wsgi curl php5 php5-mysql php5-curl php5-cli php-pear php5-dev php-apc php5-gd phpmyadmin php5-pgsql phppgadmin make build-essential libpcre3-dev libtiff4 libgif4 

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
RUN wget http://www.princexml.com/download/prince_8.1-5_ubuntu12.04_amd64.deb -O /tmp/prince_8.1-5_ubuntu12.04_amd64.deb
RUN dpkg -i /tmp/prince_8.1-5_ubuntu12.04_amd64.deb

# Add image config
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf
ADD templates/index.html /var/www/index.html
ADD templates/vhost /etc/apache2/sites-available/default
ADD templates/siv.ini /var/www/siv-v3/siv.ini
ADD templates/config.json /var/www/siv-v3/app/config.json
ADD templates/TwineHeadlessBrowser /home/TwineHeadlessBrowser

# Setup filestore
RUN mkdir -p /var/www/siv-v3/filestore
RUN chmod 777 /var/www/siv-v3/filestore

# Setup Twine tools
RUN ln -sf /docker/src/scripts/twine-tools /usr/bin/twine-tools

# Setup phpPgAdmin
RUN sed 's,allow from 127.0.0.0/255.0.0.0 ::1/128,allow from all,g' /etc/apache2/conf.d/phppgadmin > tmpfile && mv tmpfile /etc/apache2/conf.d/phppgadmin

# SSHD config
RUN mkdir /var/run/sshd
RUN echo 'root:password' |chpasswd

EXPOSE 22 80

#RUN /docker/run.sh # This casues "docker build" to never exit/ complete execution
CMD ["/usr/bin/supervisord"] 

# Test with url below in browser
#http://192.168.50.5/