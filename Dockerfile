FROM ubuntu:16.04

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_GB.UTF-8
# Update base image
# Add sources for latest nginx
# Install software requirements
RUN apt-get update && \
	apt-get install -y software-properties-common language-pack-en && \
	add-apt-repository -y -u ppa:ondrej/php && \
	nginx=stable && \
	add-apt-repository ppa:nginx/$nginx && \
	apt-get update && \
	apt-get upgrade -y && \
	BUILD_PACKAGES="wget vim supervisor nginx php7.2-fpm git php7.2-mysql php7.2-curl php7.2-gd php7.2-intl php7.2-sqlite php7.2-tidy php7.2-xmlrpc php7.2-xsl php7.2-pgsql php7.2-ldap pwgen unzip php7.2-zip curl php7.2-mbstring php-mongodb cron php-mcrypt" && \
	apt-get -y install $BUILD_PACKAGES && \
	curl -sS https://getcomposer.org/installer -o composer-setup.php && \
	php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
	composer global require hirak/prestissimo && \
	apt-get remove --purge -y software-properties-common && \
	apt-get autoremove -y && \
	apt-get clean && \
	apt-get autoclean && \
	echo -n > /var/lib/apt/extended_states && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /usr/share/man/?? && \
    rm -rf /usr/share/man/??_*

ADD . /var/www

EXPOSE 8888

CMD php /var/www/src/index.php
