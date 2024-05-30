################################################################
## Script de ejemplos y ejercicios: introducción a data.table ##
################################################################


###############################
## Importar y exportar datos ##
###############################

# Creación de objeto data.table sencillo 

library(data.table)

DT = data.table(
  ID = c("b","b","b","a","a","c"),
  a = 1:6,
  b = 7:12,
  c = 13:18
)

DT

# Leer archivo

data  <- fread("data/sub_100000_plantae_mexico_conCoords_specimen.csv")

head(data)

# Escribir archivo

fwrite(data, "data/testDT.csv", sep = ",")

# Opcional (escribir archivo comprimido)

# fwrite(data, "data/plantae_mexico_conCoords_specimen.csv.gz", sep = ",", compress = "auto")

##################################################
## Operaciones sobre las filas: filtros y orden ##
##################################################

# Filtros por índices

data[1:2] 

data[1:2,] 

# Filtros por condicion

data_quercus <- data[genus == "Quercus",] 

dim(data_quercus)

data_quercus_viejos <- data[genus == "Quercus" & year <= 1950,]

dim(data_quercus_viejos)


# Ordenar filas 

ordered_data = data_quercus[order(stateProvince)]

unique(ordered_data$stateProvince)


## Ejercicio: 

# 1. Carga el archivo de registros de plantas utilizando la función fread que revisamos en el tema anterior
# 2. Utiliza un filtro para quedarte con las filas que pertenezcan a un género o especie que te guste
# 3. Ordena de manera descendente por año

# Pregunta:

# ¿De qué año son los registros más nuevos y más viejos de la especie que escogiste? (selecciona utilizando 
# rangos la primera y la última fila de la tabla)



##################################################
## Operaciones sobre las columnas: seleccion #####
##################################################

# Seleccionar por indice

data[,7:8,]

# Seleccionar por nombre

data[,species] 

# Seleccionar múltiples columnas

data[,list(family,genus,species)]

data[,.(family,genus,species)]

# Seleccionar multiples columnas guardadas en una variable

variables <- c("family","genus","species")

data[ , ..variables]

## Ejercicio:

# 1. Selecciona las columnas que contengan información 
# acerca de la ubicación geográfica de los registros.

# Renombrar columnas

data[, .(especie = species, genero = genus)]


##################################################
## Operaciones sobre las columnas: Modificacion ##
##################################################



##################################################
## Operaciones sobre las columnas: Agrupacion ####
##################################################



##################################################
## Cadenas de operaciones ########################
##################################################

# Ejemplo de cadenas de operaciones

# 1. Seleccionar los registros del género Quercus y filtrar aquellos que 
# no tienen información acerca de la especie o del año de colecta

data[genus == "Quercus" & !is.na(species) & species != "" & !is.na(year)]

# 2. Agrupar por especie y por año de colecta

# 3. Contar el número de registros de que se 
# realizó para cada especie en cada año

data[genus == "Quercus" & !is.na(species) & species != "" & !is.na(year), .(.N), by = .(year,species)]

# 4. Ordenar la columna de número de registros de mayor a menor


data[genus == "Quercus" & !is.na(species) & species != "" & !is.na(year), .(N = .N), by = .(year,species)][order(year,-N)]


##################################################
## Uniones entre tablas ##########################
##################################################


dt1 = data.table(id = seq(1,10), letter1 = LETTERS[sample(1:10, replace = T)])

dt2 = data.table(id = seq(6,15), letter2 = LETTERS[sample(1:10, replace = T)])

# Función merge

# inner join
merge(dt1,dt2,by = "id")

# left join
merge(dt1,dt2,by = "id", all.x = T)

# right join
merge(dt1,dt2,by = "id", all.y = T)

# full join
merge(dt1,dt2,by = "id", all = T)

# Sintaxis de data.table

# inner join
dt1[dt2, on = "id", nomatch=0]

# left join
dt1[dt2, on = "id"]

# right join
dt2[dt1, on = "id"]