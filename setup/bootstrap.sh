#!/usr/bin/env bash

# Set to noninteractive
DEBIAN_FRONTEND=noninteractive

# Load configurations
. /etc/dev-dashboard/config/build.conf

# PHPMyadmin and MariaDB password.
PASSWORD=$db_password

# update / upgrade
sudo -E apt-get update
sudo -E apt-get -y upgrade

echo -e "\e[32mUpgrade Complete\e[0m"

# install apache php
sudo -E apt-get install -y apache2
sudo -E apt-get install -y php

echo -e "\e[32mApache/PHP Install Complete\e[0m"

# install mariadb and give password to installer
sudo -E debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo -E debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo -E apt-get install -y mariadb-server
sudo -E apt-get install -y php-mysql

echo -e "\e[32mMariaDB Install Complete\e[0m"

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mariadb and phpmyadmin
sudo -E debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo -E debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo -E debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo -E debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo -E debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo -E apt-get -y install phpmyadmin

echo -e "\e[32mphpMyAdmin Install Complete\e[0m"

# install randomgoat stuff
sudo -E apt-get install -y php-xml
sudo -E apt-get install -y php.mbstring
sudo -E apt-get install -y php-json
sudo -E apt-get install -y php-curl

echo -e "\e[32mExtra PHP Stuff Install Complete\e[0m"

# install misc
sudo -E apt-get install -y vim

echo -e "\e[32mMisc Install Complete\e[0m"

# install/configure git
sudo -E apt-get install -y git
git config --global user.email "michael@jeremehancock.com"
git config --global user.name "Jereme Hancock"

echo -e "\e[32mGit Install/Configure Complete\e[0m"

# restart apache
sudo -E service apache2 restart

echo -e "\e[32mApache Restart Complete\e[0m"
