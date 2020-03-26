#!/bin/sh
# Crea el directorio WS
rutaDefaultWS="/srv/http"
if [ -d $rutaDefaultWS ]; then
        echo "existe $rutaDefaultWS"
        cd $rutaDefaultWS
else
        mkdir $rutaDefaultWS
        cd $rutaDefaultWS
fi

# Directorio que contiene la aplicación
directorioSitio="vrtg"
if [ -d $directorioSitio ]; then
        # La aplicación ya existe, sólo actualiza
        echo "existe $directorioSitio"
        cd $directorioSitio
        git checkout -- .
        git reset HEAD .
        git clean -df
        git checkout -- .
        git pull origin master
else
        # La aplicación no existe, descarga por completo
        git clone -b master https://github.com/ValdrST/vrtg.git $directorioSitio
        cd $directorioSitio
        sh dependencias.sh
        sh crearSitio.sh
fi