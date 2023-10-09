#!/bin/bash

#Muestra todos los comandos que se van ejecutando
set -x

#Actualizamos los repositorios
#apt update

#Actualizamos los paquetes
#apt upgrade -y

#Instalamos el servidor web Apache
sudo apt install apache2 -y

#Instalamos el gestor de bases de datos MySQL
sudo apt install mysql-server -y

#Instalamos PHP
apt install php libapache2-mod-php php-mysql -y

#Copiar el archivo de configuración de Apache
cp ../conf/000-default.conf /etc/apache2/sites-available

#Reiniciamos el servicio de Apache
systemctl restart apache2

#Copiamos el archivo de prueba de PHP
cp ../php/index.php /var/www/html

#Modificamos el propietario y el grupo del directorio /var/www/html
chrow -R www.data:www-data /var/www/html
