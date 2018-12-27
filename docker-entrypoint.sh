#!/bin/bash
set -e

confDir="/var/www/config"

if [[ ! -e $confDir ]]; then
    mkdir $confDir
    chown www-data:www-data $confDir
fi

chown www-data:www-data $confDir

#service apache2 restart

#watch tail /var/log/apache2/error.log /var/log/apache2/access.log
apache2ctl -D FOREGROUND

exec "$@"