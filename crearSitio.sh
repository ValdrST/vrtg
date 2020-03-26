#!/bin/sh

# Solicita la IP
echo "Indique el número de servidor:"
echo "1. venganzaiii.somch.org"
echo "2. somch.org"
read numeroServidor
# Determina si el Servidor es válido
case ${numeroServidor} in
	"1") 
	ip=venganzaiii.somch.org
	;;
	"2") 
	ip=somch.org
	;;
	*) 
	echo "Servidor no válido"
	exit 1
	;;
esac

# Solicita el puerto
echo "***********************************"
echo "Puerto [8008,8009,8010,8011,8012,8013,8014,8015,8016,8017]:"
read numeroPuerto

# Determina si el puerto esta disponible
estadoPuerto=`netstat -tuln | grep LISTEN | grep -c :$numeroPuerto`

if [ $estadoPuerto -ge 1 ]
then
        echo "Abortando: El puerto $numeroPuerto ya se encuentra en uso"
        exit 1
fi

cp vrtgd.service /etc/systemd/system/
systemctl daemon-reload
sudo systemctl start vrtgd
sudo systemctl enable vrtgd

# Solicita Directorio para nuevo sitio
echo "***********************************"
echo "Directorio para el sitio a crear:"
read nombreDirectorio

# Genera nombre de los archivos
archivoConfiguracionNGINX=/etc/nginx/sites-available/$nombreDirectorio-proxy.conf
directorioSitioNGINX=/usr/share/nginx/html/$nombreDirectorio-proxy
touch $archivoConfiguracionNGINX
rm -rf $archivoConfiguracionNGINX
rm -rf $directorioSitioNGINX

	# Crea el archivo de configuración NGINX del sitio
	echo "server{
        listen $numeroPuerto;
        server_name $ip;
        location /vrtg {
            proxy_pass http://unix:/run/waitress/ws-reportes.sock;
        }

}" > $archivoConfiguracionNGINX

	# Crea la carpeta de trabajo de NGINX
	mkdir $directorioSitioNGINX

	# Crea el enlace simbolico
	sitesEnabledConfig="/etc/nginx/sites-enabled/$nombreDirectorio-proxy.conf"
	if [ -d $sitesEnabledConfig ];then
		rm $sitesEnabledConfig
	fi
	sitesAvailableConfig="/etc/nginx/sites-available/$nombreDirectorio-proxy.conf"
	
	ln -s $sitesAvailableConfig $sitesEnabledConfig

	# Ajusta permisos
	chown -R http:http $directorioSitioNGINX
	chmod 750 $directorioSitioNGINX

	# Reinicia el servicio de NGINX
	systemctl reload nginx
