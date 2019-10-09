# Vagrant Setup:

<img src="https://raw.githubusercontent.com/mhancoc7/Dev-Dashboard/master/docs/assets/vagrant-dashboard.png"/>

**Pre-requisites:**

- [Vagrant](https://www.vagrantup.com/docs/cli/)

**Installation/Usage:**

- Add your ssh key to GitHub. [More info...](https://help.github.com/en/articles/about-ssh)

- Clone Dev-Dashboard `git clone git@github.com:mhancoc7/Dev-Dashboard.git Vagrant`

- Go into the Vagrant directory `cd Vagrant`

- Configuration options are located in the `setup/build.conf` directory.
  - git_user = Your GitHub username.
  - git_array = An array of the repos from your GitHub account that you would like to include in your dashboard.

- The MariaDB password can be set on line 4 of the `setup/bootstrap` file.

- Run `bash build.sh`

- Dev Dashboard can be located via http://localhost:8080

- Use Vagrant commands to stop, start, and destroy Vagrant from the Vagrant directory. [More info...](https://www.vagrantup.com/docs/cli/)

When using the Vagrant setup your repos are cloned to your local maching under `localhost/www/html` and are syned to the Vagrant box. This way you can destroy and recreate the Vagrant box without worrying about your code. 

If you want to add more projects after intial setup you can either add repos to the `setup/build.conf` file and re-run `bash build.sh` or manually clone repos into the `localhost/www/html/` directory and they should show up in your dashboard.

The `Labs` section of the dashboard is there for tinkering with GitHub repos and other projects. So you can clone a GitHub repo manually into `localhost/www/html` to test out some code. This section is not meant to be persistent but more of a sandbox.
