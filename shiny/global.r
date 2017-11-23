library(shiny)
library(andsport)
library(stringi)
library(dplyr)
library(hash)

#Cargamos los datasets
data(entidades)
data(pueblos)
data(instalaciones)

#Añadiendoceros
entidades$CPRO <- sprintf("%02d", entidades$CPRO)
entidades$COD_MUN <- sprintf("%05d", entidades$COD_MUN)
instalaciones$CPRO <- sprintf("%02d", instalaciones$CPRO)
instalaciones$CMUN <- sprintf("%05d", instalaciones$CMUN)
pueblos$COD_MUN <- sprintf("%05d", pueblos$COD_MUN)


#Poniendo los nombres de los pueblos bien 
pueblos_sort <- pueblos[order(pueblos$Municipio), ]
choices_muni = setNames(pueblos_sort$COD_MUN, stringi::stri_trans_totitle(pueblos_sort$Municipio))
entidades$Deporte <- stringi::stri_trans_totitle(entidades$Deporte)

#Estableciendo formato ts
entidades$Fechainscripcion <- strptime(entidades$Fechainscripcion, format = "%d/%m/%Y") 
entidades$Fechainscripcion <- as.Date(entidades$Fechainscripcion)