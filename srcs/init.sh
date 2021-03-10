#!bin/bash
mkdir -p /var/www/localhost
cd /var/www/localhost

#setup phpMyAdmin
mv /root/phpMyAdmin.tar.gz ./
tar -xvf phpMyAdmin.tar.gz
mv phpMyAdmin-5.1.0-all-languages ./phpMyAdmin
cp /root/config.inc.php ./phpMyAdmin
rm ./phpMyAdmin.tar.gz

#setup wordpress
mv /root/wordpress.tar.gz ./
tar -xvf wordpress.tar.gz
mv /root/wp-config.php ./wordpress
rm ./wordpress.tar.gz
chown -R www-data:www-data /var/www/localhost

#gen ssl key + set autoindex on or off
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/CN=localhost"
ln -s /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-enabled/localhost.conf
if [ "$AUTOINDEX" != "1" ]
	then
	sed -Ei 's/autoindex on;/autoindex off;/g' /etc/nginx/sites-available/localhost.conf
fi

#start services + DB
service php7.3-fpm start
service nginx start
service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root
echo "CREATE USER 'user42'@'%' IDENTIFIED BY 'user42';" | mysql -u root
echo "GRANT ALL ON wordpress.* TO 'user42'@'%';" | mysql -u root

#allow to check files easier after run
bash
