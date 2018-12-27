FROM ubuntu:18.04
RUN apt-get update \
	&& apt-get install -y software-properties-common -y \
	&& apt-get update -y \
	&& add-apt-repository ppa:openjdk-r/ppa -y \
#	&& apt-get install openjdk-8-jdk -y \
	&& apt-get install openjdk-8-jre -y \
	&& apt-get install zookeeper -y \
	&& apt-get install wget -y \
	&& apt-get install build-essential -y \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata \
	&& cd / \
	&& mkdir zookeeper \
	&& cd zookeeper \
	&& wget http://www-eu.apache.org/dist/zookeeper/stable/zookeeper-3.4.12.tar.gz \
	&& tar -xzf zookeeper-3.4.12.tar.gz \
	&& cd /zookeeper/zookeeper-3.4.12/src/c \
	&& ./configure \
	&& make \
	&& make install \
	&& apt install apache2 -y \
	&& service apache2 start \
	&& apt install curl -y\
	&& apt install mysql-server -y\
	&& apt install php libapache2-mod-php php-mysql -y\
	&& apt-get install php-bcmath -y\
	&& apt-get install php-mbstring -y\
	&& service apache2 restart\
	&& cd /var && mkdir php-zookeeper\
	&& cd /var/php-zookeeper && wget https://github.com/php-zookeeper/php-zookeeper/archive/v0.4.0.tar.gz\
	&& tar -zxvf v0.4.0.tar.gz\
	&& apt-get install php-dev -y \
	&& cd php-zookeeper-0.4.0 \
	&& phpize \
	&& ./configure \
	&& make \
	&& make install \
	&& echo "extension=zookeeper.so" >> /etc/php/7.2/apache2/php.ini \
	&& a2enmod rewrite \
	&& service apache2 restart

RUN apt-get install pkg-config libssl-dev -y
RUN apt-get update \
	&& apt-get install libapache2-mod-security2 -y

RUN pecl install mongodb \
	&& echo "extension=mongodb.so" >> /etc/php/7.2/apache2/php.ini \
	&& echo "extension=mongodb.so" >> /etc/php/7.2/cli/php.ini \
	&& echo "extension=zookeeper.so" >> /etc/php/7.2/cli/php.ini \
	&& service apache2 restart

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install php-gmp -y

RUN apt-get install php-curl -y
RUN apt-get install composer -y

RUN composer --version

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backward compatibility
ENTRYPOINT ["docker-entrypoint.sh"]
#ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]

EXPOSE 80 443