#!/bin/bash

# Use SSL Certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/certs/my_localhost.key -out /etc/ssl/certs/my_localhost.pem \
-subj "/C=FR/ST=Paris/L=Paris/O=42/CN=my_localhost"

# nginx
mkdir /var/www/my_localhost
cp my_localhost /etc/nginx/sites-available
ln -s /etc/nginx/sites-available/my_localhost /etc/nginx/sites-enabled/

# mysql
service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root
echo "CREATE USER 'user'@'localhost' IDENTIFIED BY 'user'" | mysql -u root
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'user'@'localhost' WITH GRANT OPTION;" | mysql -u root
#echo "FLUSH PRIVILEGES;" | mysql -u root

# wordpress
wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
mv wordpress /var/www/html
chown -R www-data:www-data /var/www/html/wordpress
cp wp-config.php /var/www/html/wordpress

#phpmyadmin

# Start all services required
service nginx start

tail -f /var/log/nginx/access.log /var/log/nginx/error.log
