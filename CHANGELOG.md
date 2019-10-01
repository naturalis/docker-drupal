# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),

## [0.0.1] 
- Drupal7 compatible

## [0.0.2] - 11-09-2019
### drupal-php container
- php7.1 -> php7.3
- unzip package added
- Apache2 logging changed from /var/log/apache2 to stderr / stdout
- Added wait-for-it.sh script which waits for mysql connection before installing drupal
- Changed ENTRYPOINT to CMD so wait-for-it.sh may run first
- added settings.php.template in container instead of depending on volume mount using docker-compose

#### entrypoint script changes
- Added trusted_host_patterns variable
- Added chmod www-data after drush bootstrap
- removed install_profile option
- commented drush dl command

### Docker-compose changes

#### docker-compose.yml
- Version 2.1 to version 3.4
- Log rotation definition changes for all containers
- Drupal image version can be managed by setting PHP_DRUPAL_TAG
- Removed config volume, config template is moved into the container
- Removed /var/log/apache2 volume, apache logs to stderr/stdout
- depends_on condition removed, this feature is not available in compose version 3 and up. wait-for-it.sh is added to container as alternative
- Traefik version changed from 1.7.2 to 1.7.14
- Traefik environment entries added for TRANSIP DNS verifications
- Traefik transip key volume added
- Treafik /etc/letsencrypt volume removed. 

#### env.dist
- Added DRUPAL_TRUSTED_HOST_PATTERNS
- Added PHP_DRUPAL_TAG
- Changed DRUPAL_VERSION to 8.7.7 
- Changed DRUPAL_MD5 to match version 8.7.7
- Changed DRUSH_VERSION to  9.7.1

## [0.0.3]

### Docker-compose changes

#### docker-compose.yml
- Changed traefik 1.x to 2.x
- Replaced traefik volume mappings to single folder mapping ( /etc/traefik )
- Changed labels for drupal service to match version 2.x.x of traefik
- Changed default certificate resolver in service label to route53 ( amazon )
- Added variables for route53

#### files and folders
- Added certificate resolver for route53 in treafik/treafik-dev.toml
- Moved all traefik related files to traefik folder
- Added dynamic-conf.toml for fixed middleware setup which rewrites http to https. 