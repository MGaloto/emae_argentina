
# EMAE Argentina


<p>
<a href="https://pkgs.rstudio.com/flexdashboard/" rel="nofollow"><img src="https://raw.githubusercontent.com/rstudio/hex-stickers/master/PNG/flexdashboard.png" align="right" width="150" style="max-width: 100%;"></a>
</p>




### Contenido:
<br>
</br>

- [**Introduccion**](https://github.com/MGaloto/emae_argentina#introduccion)
- [**Github Actions**](https://github.com/MGaloto/emae_argentina#github-actions)
- [**Librerias**](https://github.com/MGaloto/emae_argentina#librerias)
- [**Dashboard**](https://github.com/MGaloto/emae_argentina#dashboard)
- [**Ejecucion**](https://github.com/MGaloto/emae_argentina#ejecucion)
- [**Comentarios Finales**](https://github.com/MGaloto/emae_argentina#comentarios)



## Introduccion


<div style="text-align: right" class="toc-box">
 <a href="#top">Volver al Inicio</a>
</div>

<br>
</br>

Proyecto sobre un aplicacion [flexdashboard](https://pkgs.rstudio.com/flexdashboard/) utilizando datos del Indec para representar el estimador mensual de la actividad economica de los sectores de Argentina. 

La idea principal es poder tener datos actualizados de las estadisticas sobre el EMAE utilizando series temporales y distintos indicadores para ver de forma dinamica y estatica la economia Argentina.

Por ultimo, se va a utilizar [Docker](https://www.docker.com/) para crear una imagen y [Github Actions](https://docs.github.com/es/actions) para automatizar el dashboard.

<p align="center">
  <img width="650" height="450" src="images/emae.gif">
</p>



### Incluye

- ETL. ✅ 
- Series Temporales. ✅  
- Estadistica Descriptiva. ✅ 

### Estructura del Repositorio

``` shell
.
├── bash
├── docker-compose.yml
├── index.Rmd
├── download_emae.R
├── .github
├── docker
├── docs
└── images
```

- La carpeta `bash` se usa para almacenar scripts de bash que se usan en el flujo de trabajo de Acciones de Github.
- `docker-compose.yml` se utiliza para setear volumes, imagen y puertos para ejecutar el trabajo.
- `index.Rmd` contiene el trabajo principal.
- `download_emae.R` contiene el ETL.
- `.github` contiene el WorkFlow.
- `docker` contiene todos los archivos de configuración de imágenes de Docker (por ejemplo, Dockerfiley algunos archivos auxiliares)
- `docs` se usa para almacenar los archivos del tablero renderizados.
- Todas las imágenes del archivo README se almacenarán en `images`.

## Github Actions


<div style="text-align: right" class="toc-box">
 <a href="#top">Volver al Inicio</a>
</div>

<br>
</br>

Github Actions es una herramienta de CI/CD que permite programar y activar trabajos (o scripts). Se puede utilizar para:

* Automatizacion de ETL, Dashboards e Informes.

Para este trabajo se utiliza el siguiente workflow:

* El dashboard se actualiza el dia 1 del mes a las 18 hs argentina (UTC-3)

``` yaml
name: Dashboard Refresh

on: 
  push:
    branches: [main]
  schedule:  
    - cron: '0 21 1 * *' # el dia 1 del mes a las 18 hs argentina
```

## Librerias


<div style="text-align: right" class="toc-box">
 <a href="#top">Volver al Inicio</a>
</div>

<br>
</br>




La imagen contiene las librerias necesarias para ejecutar la App en un contenedor Docker y ademas poder probar distintas funcionalidades que tienen las librerias {flexdashboard} y {highcharter}. Tambien contiene librerias como {dplyr} y {tidyverse} para manipular la data.

Las siguientes librerias son las principales (No todas) que se van a configurar para compilar las capas de la imagen desde el archivo Dockerfile:

``` json
{
"packages": [
        {
            "package": "cpp11",
            "version":"0.4.2"
        },
        {
            "package": "flexdashboard",
            "version":"0.5.2"
        },
        {
            "package": "dplyr",
            "version":"1.0.9"
        },
        {
            "package": "highcharter",
            "version":"0.9.4"
        },
        {
            "package": "readr",
            "version":"2.1.2"
        },
        {
            "package": "lubridate",
            "version":"1.8.0"
        },
        {
            "package": "languageserver",
            "version":"0.3.13"
        },
        {
            "package": "httpgd",
            "version":"1.3.0"
        },
        {
            "package": "tidyverse",
            "version":"1.3.0"
        },
        {
            "package": "readxl",
            "version":"1.4.0"
        },
        {
            "package": "readr",
            "version":"2.0.2"
        },
        {
            "package": "httr",
            "version":"1.4.2"
        },
        {
            "package": "writexl",
            "version":"1.4.0"
        },
        {
            "package": "rsconnect",
            "version":"0.8.25"
        }
        
       
    ]
}
```








## Dashboard

<div style="text-align: right" class="toc-box">
 <a href="#top">Volver al Inicio</a>
</div>

<br>
</br>


[Dashboard](https://mgaloto.github.io/emae_argentina/)


## Ejecucion


<div style="text-align: right" class="toc-box">
 <a href="#top">Volver al Inicio</a>
</div>

<br>
</br>

Se puede crear una nueva imagen en base al Dockerfile existente como tambien agregar nuevas dependencias y crear una imagen con un tag. En el caso de que se use la imagen mgaloto/flexdash_high:01 esta misma ya cuenta con las dependencias para ejecutar el trabajo.

Para correr el script en local hay que ejecutar el siguiente comando de docker compose:

``` shell
docker-compose up -d
```

En el puerto 8787 se va a poder ingresar a R y ejecutar el index.Rmd (Recordar previamente modificar el docker-compose.yml con el directorio local del trabajo.)

Para darle stop al contenedor:

``` shell
docker-compose down
```



## Comentarios

<div style="text-align: right" class="toc-box">
 <a href="#top">Volver al Inicio</a>
</div>

<br>
</br>

Para terminar el proyecto del dashboard todavía faltan los siguientes items:

* Series temporales de tasas interanuales por sector.
* Indicadores de recesión.
* Nuevos indicadores de aceleración y desaceleración de sectores.
