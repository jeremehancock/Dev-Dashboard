#!/bin/bash

picheck="/var/www/html/config/pizero"
config="/var/www/html/config"

# Check for Pi Zero and set picheck file
if [[ "$HOSTNAME" == "pizero.local" || "$HOSTNAME" == "raspberrypi" ]]; then
  if [ ! -d "$config" ]; then
    sudo mkdir -p "$config"
  fi

  if [ ! -f "$picheck" ]; then
    sudo touch "$picheck"
  fi
fi

# Build script options menu
while [ -n "$1" ]; do 
    case "$1" in
    -hn)
        param="$2"
        hostname="$param"
        shift
        ;;
    -h)
        if [ -f "$picheck" ]; then
          echo "Use '-hn <hostname>' to set new hostname."
          echo "Default hostname will be set to pizero.local if not specifically defined."
        else
          echo "Run 'bash build.sh to setup your Vagrant Dev Dashboard."
        fi
        exit
        shift
        ;;
    *) echo "Option $1 not recognized" ;;
    esac
    shift
done

# Load configurations
. setup/config/build.conf

if [ -f "$picheck" ]; then

  echo -e "\e[96m*************************** Copy Configurations for Pi Zero *********\e[0m"
  sudo mkdir -p /etc/dev-dashboard/config
  sudo cp setup/config/build.conf /etc/dev-dashboard/config/build.conf

  echo -e "\e[96m*************************** Run Bootstrap ***************************\e[0m"
  bash setup/bootstrap.sh

  echo -e "\e[32m*************************** Set Permissions *************************\e[0m"
  sudo chown -R pi: /var/www/html
  sudo chmod g+wx -R /var/www/html

  echo -e "\e[32m*************************** Install Dashboard ***********************\e[0m"
  cp -r "localhost/www/html" "/var/www/"
  echo "<?php \$github_user = \"$git_user\"; ?>" > /var/www/html/config/github-config.php

  echo -e "\e[32m*************************** Clone Repos *****************************\e[0m"
  for i in "${git_array[@]}"; do
    if [ ! -d /var/www/html/"${i^^}" ]; then
      git clone git@github.com:"$git_user"/"$i" /var/www/html/"${i^^}"
    fi
  done

  echo -e "\e[32m*************************** Remove Default Index File ***************\e[0m"
  if [ -f "/var/www/html/index.html" ]; then
    rm /var/www/html/index.html
  fi

  echo -e "\e[32m*************************** Enable VNC ******************************\e[0m"
  if [ ! -f "/etc/systemd/system/multi-user.target.wants/vncserver-x11-serviced.service" ]; then
    sudo ln -s /usr/lib/systemd/system/vncserver-x11-serviced.service /etc/systemd/system/multi-user.target.wants/vncserver-x11-serviced.service
    sudo systemctl start vncserver-x11-serviced
  fi

  echo -e "\e[32m*************************** Set Timezone ****************************\e[0m"
  sudo timedatectl set-timezone "$timezone"

  echo -e "\e[32m*************************** Set Locales *****************************\e[0m"
  sudo perl -pi -e 's/# "$locales_part1" "$locales_part2"/"$locales_part1" $locales_part2"/g' /etc/locale.gen
  sudo locale-gen "$locales_part1"
  sudo update-locale "$locales_part2"

  echo -e "\e[32m*************************** Expand Filesystem ***********************\e[0m"
  sudo raspi-config --expand-rootfs

  echo -e "\e[32m*************************** Set Hostname ****************************\e[0m"
  if [[ "$hostname" == "" ]]; then
    sudo hostnamectl set-hostname "pizero.local"
  else
    sudo hostnamectl set-hostname "$hostname"
  fi

  echo -e "\e[32m*************************** Set Password ****************************\e[0m"
  sudo usermod -p "$pi_password" pi

  echo -e "\e[32m*************************** Process Complete Rebooting **************\e[0m"
  sudo reboot now

else

  echo -e "\e[32m*************************** Create GitHub Config ********************\e[0m"
  echo "<?php \$github_user = \"$git_user\"; ?>" > localhost/www/html/config/github-config.php

  echo -e "\e[32m*************************** Destroy Previous Vagrant ****************\e[0m"
  vagrant destroy -f

  echo -e "\e[32m*************************** Run Vagrant Up **************************\e[0m"
  vagrant up


  echo -e "\e[32m*************************** Clone Repos *****************************\e[0m"
  for i in "${git_array[@]}"; do
    if [ ! -d localhost/www/html/"${i^^}" ]; then
      git clone git@github.com:"$git_user"/"$i" localhost/www/html/"${i^^}"
    fi
  done
fi
