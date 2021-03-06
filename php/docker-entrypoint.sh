#!/bin/bash
# set the php ini
if [[ ! -f /usr/local/etc/php.ini ]] ; then
    if [[ "$DEV" == 1 ]] ; then
        cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
    else
        cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
    fi
    # make the upload file size a lot bigger
    /bin/sed -i -E "s/upload_max_filesize = .*/upload_max_filesize = 16M/" /usr/local/etc/php/php.ini
    /bin/sed -i -E "s/post_max_size = .*/post_max_size = 16M/"  /usr/local/etc/php/php.ini
fi

# setup drupal
if [[ ! -f /opt/project/.git ]] && [[ ! -z "$PROJECT_REPO" ]] ; then
    cd /opt/project/
    git clone --recurse-submodules $PROJECT_REPO .
fi
if ! [[ -e /var/www/html/index.php ]] ; then
    rm -rf /var/www/html/*
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
    && ln -s /var/www/vendor/drush/drush/drush /usr/local/bin/drush
fi


if ! [[ -e /var/www/html/sites/default/settings.php ]] ; then
    if [[ $DRUPAL_VERSION == 7* ]] ; then
      cp /root/config/settings7.php /var/www/html/sites/default/settings.php
    else
      cp /root/config/settings8.php /var/www/html/sites/default/settings.php
    fi
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
    /bin/sed -i -E "s/@@trusted_host_patterns@@/$DRUPAL_TRUSTED_HOST_PATTERNS/" /var/www/html/sites/default/settings.php
fi
cd /var/www/html
if  [[ ! -f /opt/project/.installed ]] && (! /usr/local/bin/drush status bootstrap | grep -q Successful); then
    (yes|drush si) && touch /opt/project/.installed && chown -R www-data:www-data /var/www/html/sites/default/files

fi

#/usr/local/bin/drush @none dl registry_rebuild-7.x

# run server

/usr/sbin/apache2ctl -D FOREGROUND
