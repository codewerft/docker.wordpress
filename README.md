

docker run -d --name kochblog.database  -v /opt/volumes/mysql/kochblog:/var/lib/mysql -e 'DB_USER=kochblog' -e 'DB_PASS=CTv37bjC9XJVMfJ' -e 'DB_NAME=kochblog' codewerft/mysql

docker run -d --name kochblog.wordpress -v /opt/volumes/wordpress/kochblog:/var/www --link kochblog.database:mysql -e 'SITE_URL=http://quandolappetito.oleweidner.com' -e 'MYSQL_DB_USER=kochblog' -e 'MYSQL_DB_PASSWORD=CTv37bjC9XJVMfJ' -e 'MYSQL_DB_NAME=kochblog' -p 127.0.0.1:7000:80 codewerft/wordpress
