#!/bin/bash

DEBIAN_FRONTEND=noninteractive

# Load configurations
. /etc/dev-dashboard/config/build.conf

# phpMyAadmin and MariaDB password.
PASSWORD=$db_password

# GitHub details
GIT_EMAIL=$git_email
GIT_NAME=$git_name

echo -e "\e[96m*************************** Upgrade Packages ***************************\e[0m"
sudo -E apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

echo -e "\e[96m*************************** Install Apache/PHP *************************\e[0m"
sudo -E apt-get install -y apache2
sudo -E apt-get install -y php

echo -e "\e[96m*************************** Install MariaDB ****************************\e[0m"
sudo -E debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo -E debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo -E apt-get install -y mariadb-server
sudo -E apt-get install -y php-mysql

echo -e "\e[96m*************************** Install phpMyAdmin *************************\e[0m"
sudo -E debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo -E debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo -E debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo -E debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo -E debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo -E apt-get -y install phpmyadmin

echo -e "\e[96m*************************** Install Extra PHP Packages *****************\e[0m"
sudo -E apt-get install -y php-xml
sudo -E apt-get install -y php.mbstring
sudo -E apt-get install -y php-json
sudo -E apt-get install -y php-curl

echo -e "\e[96m*************************** Install Misc Packages **********************\e[0m"
sudo -E apt-get install -y vim

echo -e "\e[96m*************************** Install Git ********************************\e[0m"
sudo -E apt-get install -y git
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME

echo -e "\e[96m*************************** Restart Apache *****************************\e[0m"
sudo -E service apache2 restart
