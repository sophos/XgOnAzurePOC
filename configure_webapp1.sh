#!/bin/bash
# set up a silent install of MySQL
dbpass="mySQLPassw0rd"

export DEBIAN_FRONTEND=noninteractive
echo mysql-server-5.6 mysql-server/root_password password $dbpass | debconf-set-selections
echo mysql-server-5.6 mysql-server/root_password_again password $dbpass | debconf-set-selections

# install the LAMP stack
apt-get update
apt-get -y install apache2 mysql-server php7.0 php7.0-mysql  

# write some PHP
echo "<html><head><title>This is Web Server 01</title></head><body><h1>Web Server 01</h1></body></html>" > /var/www/html/index.html

# restart Apache
apachectl restart