FROM centos:7
MAINTAINER Sérgio Lima "sergiosdlima@gmail.com"

# Install some tools
RUN yum -y update && yum install -y \
    curl \
    wget \
    unzip \
    git \
    which \
  && yum clean all

# Add postgresql.org repo and install postgres client
RUN yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm \
  && yum install -y postgresql96 \
  && rm -rf /var/tmp/*

# Create a user and group used to launch processes
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
# so there is a high chance that this ID will be equal to the current user
# making it easier to use volumes (no permission issues)
RUN groupadd -r apache --gid=1000 && useradd -r -g apache --uid=1000 apache

# Install apache
RUN yum -y update && yum install -y httpd && yum clean all

# Add epel and webtatic repo then install PHP 5.6
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    https://mirror.webtatic.com/yum/el7/webtatic-release.rpm \
  && yum -y update && yum install -y \
    php56w \
    php56w-cli \
    php56w-common \
    php56w-gd \
    php56w-mbstring \
    php56w-mcrypt \
    php56w-pdo \
    php56w-pgsql \
    php56w-xml \
  && yum clean all

# Install composer
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer \
  && echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc

# Install drush
RUN composer global require drush/drush:"6.*" --prefer-dist \
  && composer global update \
  && composer global config secure-http false \
  && echo 'export DRUSH_PHP=/usr/bin/php' >> ~/.bashrc \
  && source ~/.bash_profile

# Add common virtual host for Drupal with composer build
ADD ./httpd-drupal.conf /etc/httpd/conf.d/drupal.conf

WORKDIR /var/www/html
EXPOSE 80

# Start apache service
ENTRYPOINT ["/usr/sbin/httpd", "-c", "ErrorLog /dev/stdout", "-D", "FOREGROUND"]
