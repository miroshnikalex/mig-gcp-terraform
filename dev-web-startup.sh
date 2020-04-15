#!/bin/bash

yum update -y
yum install httpd -y
service httpd start
echo "Welcome to DEV MIG" >> /var/www/html/index.html
