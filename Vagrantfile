$setup = <<SCRIPT
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

docker build -t web /var/www/docker/web
#docker build -t mongo /var/www/docker/mongo
#docker build -t postgresql /var/www/docker/postgresql

docker run -d -p 80:80 --name web web:latest
#docker run -d -p 27017:27017 --name mongo mongo:latest
#docker run -d -p 5432:5432  --name postgresql postgresql:latest

SCRIPT

$start = <<SCRIPT
docker start web
#docker start mongo
#docker start postgresql

SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure("2") do |config|

  config.vm.provider "twine" do |t|
    t.memory = 4096
    t.cpus = 2
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

