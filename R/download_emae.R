library(tidyverse)
library(lubridate)
library(readxl)
library(readr)
library(httr)

# -----------------------------
# FUNCIONES
# -----------------------------

convert_integer = function(dataframe) {
  dataframe[ , c(1:(ncol(dataframe)))] = apply(
    dataframe[ , c(1:(ncol(dataframe)))],
    2,
    function(x) as.numeric(as.character(x))
  )
  return(dataframe)
}

get_dataframe = function(url, time_out){
  
  GET(
    url,
    timeout(time_out),
    write_disk(file <- tempfile(fileext = ".xls"))
  )
  
  emae = read_excel(file)
  
  if (grepl("mensual", url)) {
    
    emae = emae[6:nrow(emae) - 1, 3]
    colnames(emae) = "emae"
    emae = na.omit(emae)
    emae = convert_integer(emae)
    
    dataframe = emae %>% 
      mutate_if(is.numeric, round)
    
  } else {
    
    emae = emae[4:nrow(emae) - 1, ]
    colnames(emae) = emae[1, ]
    emae = emae[3:nrow(emae), 3:ncol(emae)]
    emae = na.omit(emae)
    emae = convert_integer(emae)
    
    colnames(emae) = c(
      "agricultura_ganaderia",
      "pesca",
      "mineria",
      "industria_manufactura",
      "electricidad_gas_agua",
      "construccion",
      "comercio",
      "hoteles_restaurantes",
      "transporte_comunicaciones",
      "intermediacion_financiera",
      "inmobiliarias",
      "adm_publica",
      "enseñanza",
      "serv_sociales_salud",
      "serv_comunitarios_sociales",
      "impuestos_neto_subsidios"
    )
    
    periodos = seq(
      as.Date("2004/1/1"),
      by = "month",
      length.out = nrow(emae)
    )
    
    emae$periodos = as.Date(periodos)
    emae$year     = year(emae$periodos)
    emae$Mes      = as.numeric(substr(emae$periodos, 6 , 7))
    
    dataframe = emae %>% 
      mutate_if(is.numeric, round)
  }
  
  return(dataframe)
}

# -----------------------------
# URLS
# -----------------------------

url_sectors = "https://www.indec.gob.ar/ftp/cuadros/economia/sh_emae_actividad_base2004.xls"
url = "https://www.indec.gob.ar/ftp/cuadros/economia/sh_emae_mensual_base2004.xls"

# -----------------------------
# EJECUCIÓN
# -----------------------------

df_emae = get_dataframe(url = url, time_out = 20000)
dataframe = get_dataframe(url = url_sectors, time_out = 20000)

# -----------------------------
# CREAR CARPETA DATA
# -----------------------------

if (!dir.exists("data")) {
  dir.create("data")
}

# -----------------------------
# GUARDAR RAW
# -----------------------------

write_csv(df_emae, "data/rawdata.csv")

# -----------------------------
# PROCESAMIENTO FINAL
# -----------------------------

dataframe$emae = df_emae$emae

# -----------------------------
# GUARDAR PROCESADO
# -----------------------------

write_csv(dataframe, "data/processdata.csv")

# -----------------------------
# LIMPIEZA
# -----------------------------

rm(df_emae)