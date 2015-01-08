FROM ubuntu:14.04

# Add files to docker container
ADD ./ /docker/
RUN chmod 755 /docker/*.sh

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install ssh sudo supervisor openssh-server

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install mongodb-org

# Add image config
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD supervisord-mongo.conf /etc/supervisor/conf.d/supervisord-mongo.conf
ADD supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf
ADD supervisord-system.conf /etc/supervisor/conf.d/supervisord-system.conf

# MongoDB config
RUN mkdir -p /data/db
RUN export LC_ALL=C

# SSHD config
RUN mkdir /var/run/sshd
RUN echo "root:password" | chpasswd

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 27017

CMD ["/usr/bin/supervisord"] 

# Test with command below in vagrant
#sudo apt-get -y install mongodb-clients && mongo