# Pi Zero Setup:

<img src="https://raw.githubusercontent.com/mhancoc7/Dev-Dashboard/master/docs/assets/pizero-dashboard.png"/>

## Pre-requisites:

 - [Pi Zero Portable Dev Server](https://pilab.dev/raspberry-pi-portable-dev-server)

The Pi Zero installation is designed to work with a Pi Zero setup as a USB dongle. This is a more advanced setup and may not be useful to many. More info on how a Pi Zero USB dongle can be setup can be found on my [Pi Lab blog](https://pilab.dev/raspberry-pi-portable-dev-server).

Once you have a working Pi Zero USB dongle built you can use the steps below to fully set up the Pi Zero as a portable dev server. This setup assumes that you will be using the Pi Zero in a similar fashion to Vagrant. In other words don't run this on a Pi Zero where you have other things setup. The idea here is to use the Pi Zero as a dev server that can easily be rebuilt using this script.

## Installation/Usage:

- Flash Raspbian to an SD card using [Etcher](https://www.balena.io/etcher/).

- Once flashing is complete remove and reinsert the SD card. This should auto mount two directories.

- Open the `boot` directory and Put `dtoverlay=dwc2` at the end of the `config.txt`.

- Open the `boot` directory and  Put `modules-load=dwc2,g_ether` right after `rootwait` in the `cmdline.txt`

- Copy the contents of the `pre-setup/boot/` directory from this project into the `boot` directory.

- Modify the [wpa_supplicant.conf](https://github.com/mhancoc7/Dev-Dashboard/blob/master/pre-setup/boot/wpa_supplicant.conf) file that you copied into the `boot` directory with your WiFi creds.

- Unmount and remove the SD card.

- Insert the SD card into Pi Zero.

- Plug the Pi Zero USB dongle into your computer.

- SSH into the Pi Zero using `ssh pi@raspberrypi.local` with the default pi password.

- Add the Pi Zero's SSH key to GitHub. [More info...](https://help.github.com/en/articles/about-ssh)

- Clone the Dev-Dashboard
  - `git clone https://github.com/mhancoc7/Dev-Dashboard.git`

- Go into the Dev-Dashboard directory
  - `cd Dev-Dashboard`

- Configuration options are located in the [setup/config/build.conf](https://github.com/mhancoc7/Dev-Dashboard/blob/master/setup/config/build.conf) file
  - git_user = Your GitHub username
  - git_email = Your GitHub email
  - git_name = Your GitHub Name
  - git_array = An array of the repos from your GitHub account that you would like to include in your dashboard
  - db_password = The password to use for MariaDB and PHPMyadmin (The username is `phpmyadmin`)
  - pi_password = The password that you would like to use on the Pi Zero. The default is to keep the default pi password
  - timezone = The timezone to set on the Pi Zero
  - locales = The locales to use on the Pi Zero

- Run `bash build.sh`
  - (Optional: Use '-hn <hostname>' to choose hostname. If you do not specify a hostname `pizero.local` will be used.)

- The `build.sh` script will reboot the Pi Zero when complete

- The Dev Dashboard can be accessed via http://pizero.local or whatever hostname you set using the '-hn' flag

- You can SSH into the Pi Zero using `ssh pi@pizero.local` or whatever hostname you set using the '-hn' flag

- Add your computer's SSH Key to Pi Zero `ssh-copy-id pi@pizero.local` or whatever hostname you set using the '-hn' flag to make it easier to login

If you want to add more projects after intial setup just add repos to the [setup/config/build.conf](https://github.com/mhancoc7/Dev-Dashboard/blob/master/setup/config/build.conf) file and re-run `bash build.sh` and they will show up in your dashboard.

The `Labs` section of the dashboard is there for tinkering with GitHub repos and other projects. So you can clone a GitHub repo manually into `/var/www/html/*labs/` on the Pi Zero to test out the code. This section is not meant to be persistent but more of a sandbox.

# *Tips:*
- If you want to have custom icons in the dashboard list be sure that your repos have a `favicon.ico` or `favicon.png` in the root of the respective repo.

> #### `Note: All code is provided as-is without any warranty. Use at your own risk.`
