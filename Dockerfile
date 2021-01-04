# select base
FROM debian:buster
MAINTAINER bahaas <bahaas@student.42.fr>

# install dependencies
# -y option automaticcaly answer yes to confirmation
RUN apt-get update -y && apt-get install -y \
	wget \
	openssl \
	nginx \
	mariadb-server \
	php-fpm \
	php-mbstring \
	php-mysql
	
# copy files to the container
COPY srcs ./root/

# set a directory
WORKDIR /root/

# define the port number the container should expose
EXPOSE 80 443

# run the command allow to config the services included in the image
ENTRYPOINT ["bash", "init.sh"]
