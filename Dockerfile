# select base
FROM debian:buster
MAINTAINER bahaas <bahaas@student.42.fr>

#hide multiple info mssg & warning during dependecies installation
ENV DEBIAN_FRONTEND noninteractive

#declare env variable to enable autoindex on/off (on by default)
ENV AUTOINDEX=1

# define the port number the container should expose
EXPOSE 80
EXPOSE 443

# install dependencies
# -y option automaticaly answer yes to confirmation
RUN apt-get update -y && apt-get utils -y && apt-get install -y \
mariadb-server \
php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common php7.3-json php7.3-xml php7.3-opcache php7.3-readline php7.3-cgi php7.3-mbstring \
wget tar nginx

#get tar files of wordpress & phpmyadmin
RUN wget -O /root/phpMyAdmin.tar.gz https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.tar.gz
RUN wget -O /root/wordpress.tar.gz http://fr.wordpress.org/latest-fr_FR.tar.gz 

# copy files to the container
COPY srcs/init.sh /root
COPY srcs/config.inc.php /root
COPY srcs/wp-config.php /root
COPY srcs/server.conf /etc/nginx/sites-available/localhost.conf

RUN chmod +x /root/init.sh
CMD ["/root/init.sh"]
