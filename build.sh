#!/usr/bin/env bash

# Create pizero file on first run if hostname matches expected pi zero hostnames
picheck="/var/www/html/config/pizero"
config="/var/www/html/config"

if [[ "$HOSTNAME" == "pizero.local" || "$HOSTNAME" == "raspberrypi" ]]; then
  if [ ! -d "$config" ]; then
    sudo mkdir -p "$config"
  fi

  if [ ! -f "$picheck" ]; then
    sudo touch "$picheck"
  fi
fi

while [ -n "$1" ]; do # while loop starts
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
. setup/build.conf

if [ -f "$picheck" ]; then

  # run bootstrap manually
  bash setup/bootstrap.sh

  echo -e "\e[32mBootstrap Complete\e[0m"

  # Chown /var/www/html to pi:
  sudo chown -R pi: /var/www/html

  echo -e "\e[32mChown Complete\e[0m"

  # Copy dashboard to /var/www
  cp -r "localhost/www/html" "/var/www/"

  # Create GitHub Config
  echo "<?php \$github_user = \"$git_user\"; ?>" > /var/www/html/config/github-config.php

  echo -e "\e[32mWrite GitHub Config Complete\e[0m"

  echo -e "\e[32mDashboard Setup Complete\e[0m"

  # Clone Repos
  for i in "${git_array[@]}"; do
    if [ ! -d /var/www/html/"${i^^}" ]; then
      git clone git@github.com:"$git_user"/"$i" /var/www/html/"${i^^}"
    fi
  done
  echo -e "\e[32mCloning Complete\e[0m"

  if [ -f "/var/www/html/index.html" ]; then
    rm /var/www/html/index.html
  fi

  echo -e "\e[32mClean-up Complete\e[0m"

  # Enable VNC
  if [ ! -f "/etc/systemd/system/multi-user.target.wants/vncserver-x11-serviced.service" ]; then
    sudo ln -s /usr/lib/systemd/system/vncserver-x11-serviced.service /etc/systemd/system/multi-user.target.wants/vncserver-x11-serviced.service
    sudo systemctl start vncserver-x11-serviced
  fi

  echo -e "\e[32mEnable VNC Complete\e[0m"

  # Set Timezone
  sudo timedatectl set-timezone "$timezone"

  echo -e "\e[32mSetting Timezone Complete\e[0m"

  # Set locales
  sudo perl -pi -e 's/# "$locales_part1" "$locales_part2"/"$locales_part1" $locales_part2"/g' /etc/locale.gen
  sudo locale-gen "$locales_part1"
  sudo update-locale "$locales_part2"

  echo -e "\e[32mSetting Locales Complete\e[0m"

  # Resize filesystem
  sudo raspi-config --expand-rootfs

  echo -e "\e[32mFilesystem resize Complete\e[0m"

  # Change hostname
  if [[ "$hostname" == "" ]]; then
    sudo hostnamectl set-hostname "pizero.local"
  else
    sudo hostnamectl set-hostname "$hostname"
  fi

  echo -e "\e[32mHostname Update Complete\e[0m"

  # Change default pi password
  sudo usermod -p "$pi_password" pi

  echo -e "\e[32mPassword Change Complete\e[0m"

  # Reboot to ensure hostname is updated
  sudo reboot now

else

  # Create GitHub Config
  echo "<?php \$github_user = \"$git_user\"; ?>" > localhost/www/html/config/github-config.php

  # Remove any previous boxes
  vagrant destroy -f

  # Run vagrant -up
  vagrant up

  echo -e "\e[32mVagrant Complete\e[0m"

  # Clone Repos
  for i in "${git_array[@]}"; do
    if [ ! -d localhost/www/html/"${i^^}" ]; then
      git clone git@github.com:"$git_user"/"$i" localhost/www/html/"${i^^}"
    fi
  done
  echo -e "\e[32mCloning Complete\e[0m"

fi
