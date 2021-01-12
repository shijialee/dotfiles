#!/usr/bin/env bash

# Variables
APPENV=local
DBHOST=localhost
DBNAME=guopika
DBUSER=guopika
DBPASSWD=app

# prevent  dpkg-preconfigure: unable to re-open stdin error. 
# see http://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory
export DEBIAN_FRONTEND=noninteractive

if ! grep -q 'cn.archive' /etc/apt/sources.list; then
echo -e "\n--- switch to ubuntu china mirror... ---\n"
sudo sed -i 's/archive/cn.archive/' /etc/apt/sources.list 
fi

echo -e "\n--- Updating packages list ---\n"
sudo apt-get update

echo -e "\n--- Install base packages ---\n"
sudo apt-get -y install vim curl git screen exuberant-ctags unzip > /dev/null 2>&1

echo -e "\n--- Install PHP specific packages ---\n"
sudo apt-get -y install php php-fpm php-mysql php-mcrypt php-curl php-mbstring php-xml php-gd php-zip > /dev/null 2>&1

echo -e "\n--- Install nginx ---\n"
sudo apt-get -y install nginx > /dev/null 2>&1

echo -e "\n--- Install MySQL specific packages and set up MySQL root account ---\n"
echo "mysql-server mysql-server/root_password password $DBPASSWD" | sudo debconf-set-selections 
echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | sudo debconf-set-selections

sudo apt-get -y install mysql-server  > /dev/null 2>&1

echo -e "\n--- Setting up our MySQL user and db ---\n"
mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME"
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'"

echo -e "\n--- link Webapp root directory to /vagrant directory ---\n"
# nginx will create /var/www so we delete it here
sudo rm -rf /var/www
sudo ln -fs /vagrant/www /var/www

echo -e "\n--- setting timezone to Asia/Shanghai ---\n"
sudo ln -fsvn /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

echo -e "\n--- Configure php, nginx and set up fpm ---\n"
sudo tee -a /etc/nginx/php.conf >/dev/null << "EOF"
    location / {
        try_files $uri $uri/ /index.php;
    }

    location ~ .*\.php$ {
        try_files $uri =404;
        include        fastcgi_params;
        fastcgi_pass   php;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    }
EOF

sudo tee -a /etc/nginx/sites-available/dev.conf >/dev/null << "EOF"
upstream php { 
    server unix:/var/run/php-fpm.sock; 
}
server {
    listen 80;
    server_name static.guopika.example.com;
    root   /var/www/guopika.com/public/static;
}

server {
    listen   80;
    server_name guopika.example.com;
    root   /var/www/guopika.com/public;
    index index.html index.php;

    include php.conf;
}


server {
    listen   80;
    server_name pos.guopika.example.com;
    root   /var/www/pos.guopika.com/public;
    index index.php index.html;

    include php.conf;
}
############### biz.guopika.com

server {
    listen 80;
    server_name dev.static.biz.example.com;
    root   /var/www/biz.guopika.com/public/static;
}

server {
    #listen   80 default_server;
    #server_name  _;
    listen   80;
    server_name biz.guopika.example.com;
    root   /var/www/biz.guopika.com/public;
    #error_page 500 502 503 504 /50x.html;
    index index.php index.html;

    include php.conf;
}

###############  bizmobile.guopika.com

server {
    listen   80;
    server_name bizmobile.guopika.example.com;
    root   /var/www/bizmobile.guopika.com/public;
    index index.html index.php;

    include php.conf;
}
###############  dev.bizapp.guopika.com

server {
    listen   80;
    server_name bizapp.guopika.example.com;
    root   /var/www/bizapp.guopika.com/public;
    index index.html index.php;

    include php.conf;
}
###############  durian.guopika.com

server {
    listen   80;
    server_name dev.durian.example.com;
    root   /var/www/durian.guopika.com/public;
    index index.html index.php;

    include php.conf;
}
EOF

sudo ln -fs /etc/nginx/sites-available/dev.conf  /etc/nginx/sites-enabled/dev.conf
sudo service nginx reload

echo -e "\n--- install php composer to /usr/local/bin/composer ---\n"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
