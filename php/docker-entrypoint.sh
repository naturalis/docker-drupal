#!/bin/bash

# setup drupal
if [[ ! -f /opt/project/.git ]] && [[ ! -z "$PROJECT_REPO" ]] ; then
    cd /opt/project/
    git clone --recurse-submodules $PROJECT_REPO .
fi
if ! [[ -e /var/www/html/index.php ]] ; then
    rm -rf /var/www/html
    mkdir /var/www/html
    cd /var/www/html

    if [[ -e /var/www/html/ ]] ; then
        /usr/bin/curl -fSL "https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
        && echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
        && tar -xz --strip-components=1 -f drupal.tar.gz \
        && rm drupal.tar.gz \
        && chown -R www-data:www-data sites modules themes
    fi

fi
if ! [[ -e /usr/local/bin/drush ]] ; then
    cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer \
    && cd /var/www && composer require drush/drush:^$DRUSH_VERSION \
    && ln -s /var/www/vendor/drush/drush/drush /usr/local/bin/drush \
    && drush @none dl registry_rebuild-7.x
fi
if ! [[ -e /var/www/html/sites/default/settings.php ]] ; then
    cp /root/config/settings.php /var/www/html/sites/default/settings.php
    /bin/sed -i -E "s/@@protocol@@/$PROTOCOL/" /var/www/html/sites/default/settings.php
    /bin/sed -i -E "s/@@base_url@@/$BASE_URL/" /var/www/html/sites/default/settings.php
    /bin/sed -i -E "s/@@base_domain@@/$BASE_DOMAIN/" /var/www/html/sites/default/settings.php
    /bin/sed -i -E "s/@@database_name@@/$MYSQL_DATABASE/" /var/www/html/sites/default/settings.php
    /bin/sed -i -E "s/@@database_user@@/$MYSQL_USER/" /var/www/html/sites/default/settings.php
    /bin/sed -i -E "s/@@database_pass@@/$MYSQL_PASSWORD/" /var/www/html/sites/default/settings.php
    /bin/sed -i -E "s/@@database_host@@/$MYSQL_HOST/" /var/www/html/sites/default/settings.php
    /bin/sed -i -E "s/@@database_port@@/3306/" /var/www/html/sites/default/settings.php
    /bin/sed -i -E "s/@@table_prefix@@/$TABLE_PREFIX/" /var/www/html/sites/default/settings.php
    /bin/sed -i -E "s/@@install_profile@@/$INSTALL_PROFILE/" /var/www/html/sites/default/settings.php
    /bin/sed -i -E "s/@@hash_salt@@/$DRUPAL_MD5/" /var/www/html/sites/default/settings.php
fi
cd /var/www/html
if  [[ ! -f /opt/project/.installed ]] && (! /usr/local/bin/drush status bootstrap | grep -q Successful); then
    (yes|drush si) && touch /opt/project/.installed
fi

# run server
/usr/sbin/apache2ctl -D FOREGROUND
