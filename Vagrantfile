# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = config.vm.box = "ubuntu/bionic64"

  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.synced_folder "localhost/www/html/", "/var/www/html"

  config.vm.synced_folder "setup/config/", "/etc/dev-dashboard/config", create:true

  # Define the bootstrap file: A (shell) script that runs after first setup of your box (= provisioning)
  config.vm.provision :shell, path: "setup/bootstrap.sh"

end
