FROM ubuntu:12.04

# Add files to docker container
ADD ./ /docker/
RUN chmod 755 /docker/*.sh

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install ssh sudo supervisor

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install mongodb-org

# Add image config
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD supervisord-mongo.conf /etc/supervisor/conf.d/supervisord-mongo.conf
ADD supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf

# MongoDB config
RUN mkdir -p /data/db
RUN export LC_ALL=C

# SSHD config
RUN mkdir /var/run/sshd
RUN echo 'root:password' |chpasswd

EXPOSE 27017

#RUN /docker/run.sh # This casues "docker build" to never exit/ complete execution
CMD ["/usr/bin/supervisord"] 

# Test with command below in vagrant
#sudo apt-get -y install mongodb-clients && mongo