# docker-drupal

## Docker setup for Drupal sites

This document describes how to setup a Naturalis Drupal site using a dockerized environment. It is based on standard docker components:

 - php [naturalis/drupal](https://store.docker.com/community/images/naturalis/drupal)
 - mysql
 
 ## Install
 
 To get going you first should checkout this git repository. Then copy the env.dist to a .env file and change the parameters. The default
 setup is made for development purposes only.
 
 Then startup the building process by starting docker.
 
 `docker-compose up -d`
 
 This will download the docker images. Install Drupal in `www/drupal`, start the database. The basic setup has 
 no database. If you need one, you can continue the Drupal setup process. Or copy one from an existing Drupal 
 setup (preferred method).
 
 ## Configuring with an existing setup
 
 Clone a specific Drupal configuration in the `project` directory and on the drupal docker instance setup that installation by using
 drush (which should install the first time you start this docker project).
 
 ```
 docker-compose exec drupal bash
 cd /opt/project
 drush make --no-core makefile /var/www/html/
 ```
 
 Next you should dump and load the most recent database of your project. And you should be more or less set to go.
 
 
