<h1>IAW - Práctica 01</h1>
1.	Crea una máquina instancia EC2 en AWS.

2.	Le ponemos un nombre (practica-01-alexg) y seleccionamos la Amazon Machine Image (AMI) que será una de Ubuntu Server, en este caso la última versión.
![1](https://github.com/alexgcelia/practica01-iaw/assets/114919653/7d0d0247-7ade-473d-a237-94c5bedd84d0)

3.	Seleccionamos el tamaño que queremos que tenga nuestra máquina, en este caso la t2.small. En par de claves seleccionaremos la de vockey y creando la instancia debemos abrir los puertos para conectarnos por SSH y poder acceder por HTTP/HTTPS.
![2](https://github.com/alexgcelia/practica01-iaw/assets/114919653/cf06a241-3370-4d5a-827e-f6e301b58bfe)

4.  Creamos un par de claves (pública y privada) para conectar por SSH con la instancia. Nos dirigiremos a "Direcciones IP elásticas", crea una y asígnala a la instancia EC2.
![3](https://github.com/alexgcelia/practica01-iaw/assets/114919653/e67fcbeb-37a2-450f-bec4-f50df8e57453)

5.  Una vez asignada, iremos al laboratorio de nuestro AWS y descargaremos la key SSH en formato PEM. Renombramos el archivo a "vockey.pem" y la colocamos en una carpeta. 
![5](https://user-images.githubusercontent.com/114919653/234558982-675f345d-7c4d-4978-8969-7e307c539a26.png)
![6](https://user-images.githubusercontent.com/114919653/234559014-0d2c1517-9d3d-47d8-9466-f71db8263861.png)

6.  Nos conectamos a la máquina mediante ssh con el comando "ssh -i "vockey.pem" ubuntu@ec2-54-87-142-52.compute-1.amazonaws.com".

![7](https://user-images.githubusercontent.com/114919653/234559030-4643b9a9-a7ab-40f4-881f-c97fb5bd97c8.png)

7.  Ahora nos dirigiremos al Visual Studio Code, descargamos la extensión "Remote - SSH" para poder conectarnos a la máquina. Con CTRL + SHIFT + P abriremos el archivo de configuración de SSH y colocamos los siguientes datos.

![8](https://user-images.githubusercontent.com/114919653/234559329-fdcad11a-e16c-47da-9864-69059ffeaae5.png)
![9](https://user-images.githubusercontent.com/114919653/234559339-ba6eabe9-76b8-496f-a7f9-f2903ddb43c5.png)

## Creación del install_lamp.sh
### Muestra todos los comandos que se van ejecutando
set -x

### Actualizamos los repositorios
#apt update

### Actualizamos los paquetes
#apt upgrade -y

### Instalamos el servidor web Apache
sudo apt install apache2 -y

### Instalamos el gestor de bases de datos MySQL
sudo apt install mysql-server -y

### Instalamos PHP
apt install php libapache2-mod-php php-mysql -y

### Copiar el archivo de configuración de Apache
cp ../conf/000-default.conf /etc/apache2/sites-available

### Reiniciamos el servicio de Apache
systemctl restart apache2

### Copiamos el archivo de prueba de PHP
cp ../php/index.php /var/www/html

### Modificamos el propietario y el grupo del directorio /var/www/html
chown -R www-data:www-data /var/www/html


## Creación del install_tools.sh
### Muestra todos los comandos que se van ejecutando
set -x
### Se importan las variables
source .env

### Actualizamos los repositorios
#apt update -y
### Actualizamos los paquetes
#apt upgrade -y

### Configuramos las respuestas de instalación de phpMyAdmin
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
### Instalamos phpmyadmin
apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl

### Creamos un usuario que tenga acceso a todas las bases de datos
mysql -u root <<< "DROP USER IF EXISTS '$APP_USER'@'%'"
mysql -u root <<< "CREATE USER'$APP_USER'@'%'  IDENTIFIED BY '$APP_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON *.* TO '$APP_USER'@'%'"

### Instalamos Adminer
#Creamos el directorio para Adminer
mkdir -p /var/www/html/adminer
### Descargamos el archivo de Adminer
wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php -P /var/www/html/adminer
### Renombramos el nombre del archivo de Adminer
mv /var/www/html/adminer/adminer-4.8.1-mysql.php /var/www/html/adminer/index.php

### Modificamos el propietario y el grupo del directorio /var/www/html
chown -R www-data:www-data /var/www/html

### Instalamos GoAccess
apt install goaccess -y
### Creamos un directorio para los informes html de GoAccess
mkdir -p /var/www/html/stats
### Ejecutamos GoAccess en segundo plano
goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html --daemonize

### Paso 5. Configuramos la autenticacion básica de un directorio
### Creamos el archivo .htpasswd
htpasswd -bc /etc/apache2/.htpasswd $STATS_USERNAME $STATS_PASSWORD
### Copiamos el archivo de configuraciñon de Apache con la configuración del acceso al directorio
cp ../conf/000-default-stats.conf /etc/apache2/sites-available/000-default.conf
### Reiniciamos el servicio de Apache
systemctl restart apache2


## Creación del .env (Variables para las install_*.sh)
### Configuramos las variables (stats)
~~~
PHPMYADMIN_APP_PASSWORD=123456
APP_USER=usuario
APP_PASSWORD=password
STATS_USERNAME=alexg
STATS_PASSWORD=statsaccess
~~~

## Creación de los .conf (Archivos de configuración)
### Configuración
~~~
ServerSignature Off
ServerTokens Prod

<VirtualHost *:80>
    #ServerName www.example.com
    DocumentRoot /var/www/html
    DirectoryIndex index.php index.html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
~~~

### Configuración de la página de Stats (tiempo real)
~~~
ServerSignature Off
ServerTokens Prod

<VirtualHost *:80>
    #ServerName www.example.com
    DocumentRoot /var/www/html
    DirectoryIndex index.php index.html
    
    <Directory "/var/www/html/stats">
        AuthType Basic
        AuthName "Acceso restringido"
        AuthBasicProvider file
        AuthUserFile "/etc/apache2/.htpasswd"
        Require valid-user
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
~~~

### Práctica finalizada
