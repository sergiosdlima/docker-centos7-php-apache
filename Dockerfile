FROM centos:7
MAINTAINER Sérgio Lima "sergiosdlima@gmail.com"

RUN yum -y update

# install some tools
RUN yum install -y curl wget unzip git which

# add postgresql.org repo
RUN yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm

# install postgres client
RUN yum -y install postgresql96

# install apache
RUN yum install -y httpd
ADD ./httpd-drupal.conf /etc/httpd/conf.d/drupal.conf

# install PHP 5.6
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum install -y php56w php56w-cli php56w-common php56w-gd php56w-mbstring php56w-mcrypt php56w-pdo php56w-pgsql php56w-xml

# install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc

# install drush
RUN composer global require drush/drush:"6.*" --prefer-dist
RUN composer global update
RUN composer global config secure-http false

# Setup the symlink
RUN echo 'export DRUSH_PHP=/usr/bin/php' >> ~/.bashrc
RUN source ~/.bash_profile

# CLEAN UP
RUN yum clean all

WORKDIR /var/www/html
EXPOSE 80

# Start apache service
ENTRYPOINT ["/usr/sbin/httpd", "-c", "ErrorLog /dev/stdout", "-D", "FOREGROUND"]
