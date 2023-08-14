pacotes <- c("tidyverse","sf","spdep","tmap","rgdal","rgeos","adehabitatHR","knitr",
             "kableExtra","gtools","grid")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}
# Carregar a biblioteca dplyr para manipulação de dados
library(dplyr)
library(lubridate)


data <- read.csv("C:/Users/Usuário/Downloads/datatran2019.csv",sep=";",dec = ",",  stringsAsFactors = FALSE)
data_filter <- data[data$uf == "SC",]
# Se eu quisesse filtrar só os acidentes que tem mortos:
data_filter <- data_filter[data_filter$mortos >= 1,]

data$data_inversa <- as.POSIXct(data$data_inversa, format = "%Y/%m/%d %H:%M:%S")

# Extrair o mês da coluna 'data_inversa'
#mes_especifico <- 1  # 1 para janeiro
#data_filter_mes <- data_filter %>%
#  mutate(mes = month(data_inversa)) %>%
#  filter(mes == mes_especifico)

periodo_inicio <- as.POSIXct("2019-02-28")
periodo_fim <- as.POSIXct("2019-03-06")

# Filtrar por período específico
data_filter_periodo <- data_filter %>%
  filter(data_inversa >= periodo_inicio & data_inversa <= periodo_fim)

# Criando um objeto do tipo sf a partir de um data frame:
acidentes <- st_as_sf(x = data_filter_periodo, 
                      coords = c("longitude", "latitude"), 
                      crs = 4326)
#o crs 4326 que utilizamos é o sistema de coordenadas geográficas não projetadas WGS84

# Plotando os pontos com ggplot:
acidentes %>%
  ggplot()+
  geom_sf()

# também é possível plotar com a projeção de Mercator, utilizando o st_transform:

acidentes %>% st_transform(3857) %>%
  ggplot() +
  geom_sf()

#outra forma de visualizar é com o tm_shape com o modo tmap, que vai utilizar um mapa interativo como base
# Adicionando uma camada de um mapa do Leafleet
tmap_mode("view")

tm_shape(shp = acidentes) + 
  tm_dots(col = "deepskyblue4", 
          border.col = "black", 
          size = 0.2, 
          alpha = 0.8)

#Outra forma de fazer é utilizar um arquivo ShapeFile com formas geométricas, polígonos
# Carregando um shapefile:
shp_sc <- readOGR(dsn = "C:/Users/Usuário/Documents/ciencia de dados/Análise em R/shapefile_sc", 
                  layer = "sc_state",
                  encoding = "UTF-8", 
                  use_iconv = TRUE)

# Visualizando o shapefile carregado:
tm_shape(shp = shp_sc) +
  tm_borders()

# o modo abaixo permite gerar os gráficos para salvar, mas não para interagir
# tmap_mode("plot")

#unindo as duas observações com ggplot:
cidades <- st_read("C:/Users/Usuário/Documents/ciencia de dados/Análise em R/shapefile_sc/sc_state.shp")
cidades %>% st_transform(4326) %>%
  ggplot() +
  geom_sf() +
  geom_sf(data=acidentes)

#Utilizando o mapa interativo:
tm_shape(shp = cidades) +
  tm_borders()+
  tm_shape(shp = acidentes)+
  tm_dots()

cidades <- cidades %>% st_transform(4326)
acidentes <- acidentes %>% st_transform(4326)
cidades <- cidades %>% rename("municipio"="NM_MUNICIP")
cidades_acidentes <- cidades  %>% 
  st_join(acidentes) 
cidades_num_acidentes <- cidades %>% 
  st_join(acidentes) %>%
  group_by(municipio.x) %>%
  summarize(total_acidentes = sum(!is.na(data_inversa))) %>%
  filter(total_acidentes >= 1)  # Filtra apenas as cidades com pelo menos um acidente

cidades_num_acidentes %>%
  ggplot() +
  geom_sf(aes(fill = total_acidentes)) +
  scale_fill_gradient(low = "blue", high = "red") +
  labs(fill = "Total de Acidentes")
#outra forma:


tm_shape(shp = cidades_num_acidentes) +
  tm_fill(col = "total_acidentes", alpha = 0.2) +
  tm_borders() +
  tm_shape(shp = acidentes) +
  tm_dots(size = 0.01, alpha = 0.2)
