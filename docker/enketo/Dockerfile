FROM ubuntu:14.04

# Add files to docker container
ADD ./ /docker/
RUN chmod 755 /docker/*.sh

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install ssh sudo supervisor software-properties-common python-software-properties openssh-server

# Add image config
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf
ADD supervisord-redis-main.conf /etc/supervisor/conf.d/supervisord-redis-main.conf
ADD supervisord-redis-cache.conf /etc/supervisor/conf.d/supervisord-redis-cache.conf
ADD supervisord-pm2.conf /etc/supervisor/conf.d/supervisord-pm2.conf

RUN /docker/start-system.sh

# SSHD config
RUN mkdir /var/run/sshd
RUN chmod 0755 /var/run/sshd
RUN echo "root:password" | chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22 8005

CMD ["/usr/bin/supervisord"] 
