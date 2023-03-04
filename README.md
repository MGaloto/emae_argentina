
# EMAE Argentina


<p>
<a href="https://pkgs.rstudio.com/flexdashboard/" rel="nofollow"><img src="https://raw.githubusercontent.com/rstudio/hex-stickers/master/PNG/flexdashboard.png" align="right" width="150" style="max-width: 100%;"></a>
</p>




### Contenido:
<br>
</br>

- [**Introduccion**](https://github.com/MGaloto/emae_argentina#introduccion)
- [**Librerias**](https://github.com/MGaloto/emae_argentina#librerias)
- [**Dashboard**](https://github.com/MGaloto/emae_argentina#dashboard)
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
  [
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
        "package": "markdown",
        "version":"1.1"
    },
    {
        "package": "tidyverse",
        "version":"1.3.1"
    },
    {
        "package": "readxl",
        "version":"1.4.0"
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
