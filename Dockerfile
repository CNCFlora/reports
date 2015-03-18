FROM debian:wheezy

RUN sed -i -e 's/http.debian.net/ftp.us.debian.org/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install apache2 libapache2-mod-php5 php5 php5-cli php5-curl php5-common php5-sqlite php5-mysql php5-pgsql php5-gd supervisor -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite 

RUN sed -i -e 's/memory_limit.*/memory_limit=512M/g' /etc/php5/apache2/php.ini && \
    sed -i -e 's/upload_max_filesize.*/upload_max_filesize=128M/g' /etc/php5/apache2/php.ini && \
    sed -i -e 's/post_max_size.*/post_max_size=128M/g' /etc/php5/apache2/php.ini && \
    sed -i -e 's/display_errors.*/display_erros=On/g' /etc/php5/apache2/php.ini

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/apache2.pid
ENV PHP_ENV production

ADD default.conf /etc/apache2/sites-available/default

RUN rm /var/www/* -Rf

EXPOSE 80

RUN mkdir /var/log/supervisord
ADD supervisor.conf /etc/supervisor/conf.d/base.conf
CMD ["supervisord"]

ADD . /var/www/
RUN chown www-data.www-data /var/www/ -Rf

