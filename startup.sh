#!/bin/bash

[ -z "$MYSQL_PORT_3306_TCP_ADDR" ] && echo "Docker link to MySQL instance (alias 'mysql') missing." && exit 1;

if [ ! -f /var/www/wp-config.php ]; then

  echo "No /var/www/wp-config.php found. Installing new WordPress instance"
  [ -z "$MYSQL_DB_NAME" ] && echo "MYSQL_DB_NAME must be set to the name of the new WordPress database." && exit 1;
  [ -z "$MYSQL_DB_USER" ] && echo "MYSQL_DB_USER must be set to the name of the database user." && exit 1;
  [ -z "$MYSQL_DB_PASSWORD" ] && echo "MYSQL_DB_PASSWORD must be set to the name of the database user's password." && exit 1;

  # Download and Install WordPress
  #
  wget https://wordpress.org/latest.tar.gz 
  tar xvzf /latest.tar.gz
  mv /wordpress/* /var/www/
  mkdir /var/www/wp-content/uploads
  chown -R www-data:www-data /var/www/
  rm -r /wordpress /latest.tar.gz

  # Initial configuration
  #
  sed -e "s/database_name_here/$MYSQL_DB_NAME/
  s/localhost/$MYSQL_PORT_3306_TCP_ADDR/
  s/username_here/$MYSQL_DB_USER/
  s/password_here/$MYSQL_DB_PASSWORD/
  /'AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'SECURE_AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'LOGGED_IN_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'NONCE_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'SECURE_AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'LOGGED_IN_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
  /'NONCE_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/" /var/www/wp-config-sample.php > /var/www/wp-config.php

else

  # Restarting a container with an existing installation.
  # 
  sed -i "s/.*DB_HOST.*/define('DB_HOST', '$MYSQL_PORT_3306_TCP_ADDR');/" /var/www/wp-config.php

  [ -n "$MYSQL_DB_NAME" ] && sed -i "s/.*DB_NAME.*/define('DB_NAME', '$MYSQL_DB_NAME');/" /var/www/wp-config.php
  [ -n "$MYSQL_DB_USER" ] && sed -i "s/.*DB_USER.*/define('DB_USER', '$MYSQL_DB_USER');/" /var/www/wp-config.php
  [ -n "$MYSQL_DB_PASSWORD" ] && sed -i "s/.*DB_PASSWORD.*/define('DB_PASSWORD', '$MYSQL_DB_PASSWORD');/" /var/www/wp-config.php

fi

supervisord -n
