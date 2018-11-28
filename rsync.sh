#!/bin/bash
echo "开始解包"
tar -xf lnmp_soft.tar.gz
cd /root/lnmp_soft
echo "安装php的进程管理器"
yum -y install php-fpm-5.4.16-42.el7.x86_64.rpm
echo "创建nginx用户"
useradd -s /sbin/nologin nginx
tar -xf nginx-1.12.2.tar.gz
cd /root/lnmp_soft/nginx-1.12.2
yum -y install gcc pcre-devel openssl-devel zlib-devel
echo "配置,指定安装目录~功能模块等选项……"
./configure --prefix=/usr/local/nginx/ --user=nginx --group=nginx --with-stream --with-http_ssl_module --with-http_stub_status_module
echo "编译并将编译好的文件复制到安装目录……"
make && make install
ln -s /usr/local/nginx/sbin/nginx /sbin/
echo "启动NGINX服务"
nginx
echo "查看服务状态"
ps -ef|grep nginx
echo "开始安装动态网站涉及LNMP包"
yum -y install php php-mysql php-pecl-memcache memcached  mariadb mariadb-server mariadb-devel 
echo "启动所有服务……"
systemctl restart mariadb
systemctl enable mariadb
systemctl restart php-fpm
systemctl enable php-fpm
systemctl restart memcached
systemctl enable memcached
echo "开始替换配置文件的#"
sed -i '65,68s/#//' /usr/local/nginx/conf/nginx.conf
sed -i '70,71s/#//' /usr/local/nginx/conf/nginx.conf
sed -i '70s/fastcgi_params/fastcgi.conf/' /usr/local/nginx/conf/nginx.conf
echo "复制动态程序文件到默认目录"
cp -a /root/lnmp_soft/php_scripts/*.php /usr/local/nginx/html/








