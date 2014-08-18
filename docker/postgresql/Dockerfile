FROM ubuntu:14.04

RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

# Add files to docker container
ADD ./ /docker/
RUN chmod -R 755 /docker/

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y -q sudo supervisor ssh python-software-properties software-properties-common postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3 postgresql-9.3-postgis-2.1 postgresql-plpython-9.3 libpq-dev

# Required to allow connection to postgresql, TODO: find why and if really required
RUN mkdir /etc/ssl/private-copy; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700 /etc/ssl/private; chown -R postgres /etc/ssl/private

# Add image config
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD supervisord-postgresql.conf /etc/supervisor/conf.d/supervisord-postgresql.conf
ADD supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf
ADD src/postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
ADD src/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
RUN chown postgres:postgres /etc/postgresql/9.3/main/*.conf

# SSHD config
RUN mkdir /var/run/sshd
RUN echo 'root:password' |chpasswd

EXPOSE 5432
#CMD ["/usr/bin/supervisord"] 
CMD ["/docker/src/scripts/postgres.setup.sh"]

# Test with command below in vagrant
#sudo apt-get -y install postgresql-client && psql -h localhost -U admin postgres