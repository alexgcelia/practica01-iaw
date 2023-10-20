<h1>IAW - Práctica 01</h1>
1.	Crea una máquina instancia EC2 en AWS.

2.	Le ponemos un nombre (practica-01-alexg) y seleccionamos la Amazon Machine Image (AMI) que será una de Ubuntu Server, en este caso la última versión.

![1](https://user-images.githubusercontent.com/114919653/234554460-9e2ab5eb-7fcf-493b-b7d8-172b38995307.png)

3.	Seleccionamos el tamaño que queremos que tenga nuestra máquina, en este caso la t2.small. En par de claves seleccionaremos la de vockey y creando la instancia debemos abrir los puertos para conectarnos por SSH y poder acceder por HTTP/HTTPS.

![2](https://user-images.githubusercontent.com/114919653/234554634-afc2e475-4384-43bf-97fb-13bc371a0a12.png)

4.  Creamos un par de claves (pública y privada) para conectar por SSH con la instancia. Nos dirigiremos a "Direcciones IP elásticas", crea una y asígnala a la instancia EC2.

![3](https://user-images.githubusercontent.com/114919653/234558566-2c994b72-cd17-423f-a346-23bba2b35b1c.png)
![4](https://user-images.githubusercontent.com/114919653/234558591-49c54fc8-6607-4a12-810c-db27076ea2a7.png)

5.  Una vez asignada, iremos al laboratorio de nuestro AWS y descargaremos la key SSH en formato PEM. Renombramos el archivo a "vockey.pem" y la colocamos en una carpeta. 
![5](https://user-images.githubusercontent.com/114919653/234558982-675f345d-7c4d-4978-8969-7e307c539a26.png)
![6](https://user-images.githubusercontent.com/114919653/234559014-0d2c1517-9d3d-47d8-9466-f71db8263861.png)

6.  Nos conectamos a la máquina mediante ssh con el comando "ssh -i "vockey.pem" ubuntu@ec2-54-87-142-52.compute-1.amazonaws.com".

![7](https://user-images.githubusercontent.com/114919653/234559030-4643b9a9-a7ab-40f4-881f-c97fb5bd97c8.png)

7.  Ahora nos dirigiremos al Visual Studio Code, descargamos la extensión "Remote - SSH" para poder conectarnos a la máquina. Con CTRL + SHIFT + P abriremos el archivo de configuración de SSH y colocamos los siguientes datos.

![8](https://user-images.githubusercontent.com/114919653/234559329-fdcad11a-e16c-47da-9864-69059ffeaae5.png)
![9](https://user-images.githubusercontent.com/114919653/234559339-ba6eabe9-76b8-496f-a7f9-f2903ddb43c5.png)
