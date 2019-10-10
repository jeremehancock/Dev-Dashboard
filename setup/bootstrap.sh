#!/usr/bin/env bash

# Load configurations
. /etc/dev-dashboard/config/build.conf

# PHPMyadmin and MariaDB password.
PASSWORD=$db_password

# update / upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

echo -e "\e[32mUpgrade Complete\e[0m"

# install apache php
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y apache2
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y php

echo -e "\e[32mApache/PHP Install Complete\e[0m"

# install mariadb and give password to installer
sudo DEBIAN_FRONTEND=noninteractive debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo DEBIAN_FRONTEND=noninteractive debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y php-mysql

echo -e "\e[32mMariaDB Install Complete\e[0m"

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mariadb and phpmyadmin
sudo DEBIAN_FRONTEND=noninteractive debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo DEBIAN_FRONTEND=noninteractive debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo DEBIAN_FRONTEND=noninteractive debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo DEBIAN_FRONTEND=noninteractive debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo DEBIAN_FRONTEND=noninteractive debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install phpmyadmin

echo -e "\e[32mphpMyAdmin Install Complete\e[0m"

# install randomgoat stuff
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y php-xml
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y php.mbstring
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y php-json
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y php-curl

echo -e "\e[32mExtra PHP Stuff Install Complete\e[0m"

# install misc
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y vim

echo -e "\e[32mMisc Install Complete\e[0m"

# install/configure git
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y git
git config --global user.email "michael@jeremehancock.com"
git config --global user.name "Jereme Hancock"

echo -e "\e[32mGit Install/Configure Complete\e[0m"

# restart apache
sudo DEBIAN_FRONTEND=noninteractive service apache2 restart

echo -e "\e[32mApache Restart Complete\e[0m"
