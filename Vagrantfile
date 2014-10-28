$setup = <<SCRIPT
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

cd /var/www/
docker build -t mongo docker/mongo
docker build -t postgresql docker/postgresql
docker build -t web docker/web
docker build -t enketo docker/enketo

DOCKER_DIR=/var/www/docker/

docker run -d -p 27017:27017 -v "$DOCKER_DIR"mongo:/docker --name mongo mongo:latest
docker run -d -p 5432:5432 -v "$DOCKER_DIR"postgresql:/docker --name postgresql postgresql:latest
docker run -d -p 80:80 -v "$DOCKER_DIR"web:/docker -v "$DOCKER_DIR"web/src/siv-v3:/var/www/siv-v3 --link mongo:mongo --link postgresql:postgresql --name web web:latest
docker run -d -p 8006:8005 -p 35729:35729 --name enketo enketo:latest

SCRIPT

$start = <<SCRIPT
docker start web
docker start mongo
docker start postgresql
docker start enketo

SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure("2") do |config|

  config.vm.provider "twine" do |t|
    t.memory = 4096
    t.cpus = 2
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  
  config.vm.boot_timeout = 900
  
  config.vm.network "private_network", ip: "192.168.50.5"

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.provision "docker"

  config.vm.synced_folder ".", "/var/www"

  config.vm.provision "shell", inline: $setup

  config.vm.provision "shell", run: "always", inline: $start
end

