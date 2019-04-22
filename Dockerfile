FROM centos:centos7

#Install apache & PHP
RUN yum install httpd nano -y
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum install mod_php71w \
    php71w-opcache \
    php71w-cli \
    php71w-common \
    mod_php71w \
    php71w-mysql \
    php71w-xml \
    php71w-mysql \
    php71w-imagick \
    php71w-mcrypt \
    php71w-mbstring \
    php71w-gd \
    -y
RUN echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
RUN mkdir /etc/httpd/sites-enabled
RUN touch /etc/httpd/sites-enabled/testcmn.conf
RUN echo -e \
"<VirtualHost *:80>\n\
    DocumentRoot /var/www\n\
    <Directory "/var/www">\n\
       AllowOverride All \n\
       # Allow open access: \n\
       Require all granted \n\
    </Directory> \n\
</VirtualHost> \n"\
>> /etc/httpd/sites-enabled/testcmn.conf
RUN chown -R apache:apache /var/www
### GIT #####################################################
RUN rpm -U http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm \
    && yum install -y git


### Install Composer #########################################
RUN cd tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN yum install net-tools npm -y
WORKDIR /var/www
COPY ./ /var/www/
ADD run-startup.sh /run-startup.sh
RUN chmod -v +x /run-startup.sh

CMD ["/run-startup.sh"]