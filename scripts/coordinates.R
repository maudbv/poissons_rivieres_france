library(rgdal)
library(rworldmap)

# Import data sets 
tab <- read.csv("data/resultats peches/tableau_complet_peches.csv", h=T, sep=";", dec=".")

# Coordinate conversion

# les coordonnées des stations sont en Lambert93 ou en LambertII.
# pour les coordonnées en Lambert93, pas de problème
spatial93 <- data.frame(long_station=tab$long_station_lmbrt93, lat_station=tab$lat_station_lmbrt93)
coordinates(spatial93) <- ~long_station + lat_station
proj4string(spatial93) <- CRS("+init=epsg:2154") # définition du référentiel
#2154 pour Lambert93, 27571 à 2754 pour Lambert I à IV cf. make_EPSG() (package rgdal)
spatial93 <- spTransform (spatial93, CRS("+proj=longlat +ellps=WGS84"))
spatial93 <- data.frame(spatial93)

# pour les coordonnées en LambertII, les deux colonnes s'appellent "Ordonnée", c'est moche...
# il faudra aussi faire attention au Lambert à utiliser selon la région
spatialII <- data.frame(long_station=tab$long_lmbrtII, lat_station=tab$lat_lmbrtII)
coordinates(spatialII) <- ~long_station + lat_station
proj4string(spatialII) <- CRS("+init=epsg:27572") # définition du référentiel
spatialII <- spTransform (spatialII, CRS("+proj=longlat +ellps=WGS84"))
spatialII <- data.frame(spatialII)

long_station <- spatial93$long_station
long_station[tab$long_station_lmbrt93==0] <- spatialII[tab$long_station_lmbrt93==0, "long_station"]

lat_station <- spatial93$lat_station
lat_station[tab$long_station_lmbrt93==0] <- spatialII[tab$long_station_lmbrt93==0, "lat_station"]

#Verification
newmap <- getMap(resolution = "low")
plot(newmap, xlim =c(-5,10), ylim = c(44,48.5),xlab="Longitude (°)",ylab="Latitude (°)")
points(long_station, lat_station, las=1, col=c("blue","lightblue")[(tab$long_station_lmbrt93==0)+1])
# les deux types de projection semblent bien correspondrent.
length(long_station)
length(lat_station)




# Ecozones
# Ecoregions, watershed (CCMC2)...

#Ecoregions Illies
shape_eco <- readOGR(dsn="data/sig/ecoregions" ,layer="Ecoregions") # Illies ecoregions
proj4string(shape_eco)
shape_eco <- spTransform(shape_eco, CRS("+proj=longlat +datum=WGS84")) # re projection des coordonnées
proj4string(shape_eco)
shape_eco$AREA_ID <- as.factor(shape_eco$AREA_ID)

ecoregion  <- matrix(NA, nrow(tab), 1, dimnames=list(tab$id_operation, "ecoregion"))
for (i in 1:length(shape_eco)) {
		ecoregion[point.in.polygon(long_station, lat_station, shape_eco@polygons[[i]]@Polygons[[1]]@coords[,1], shape_eco@polygons[[i]]@Polygons[[1]]@coords[,2]) > 0,] <- as.character(shape_eco$NAME)[i]
}
length(ecoregion)

# Bassins versants
shape_bv <- readOGR(dsn="data/sig/bassins_versants" ,layer="BassinEurope") # bassins_versants
shape_bv <- shape_bv[shape_bv$Country %in% c("France","Spain","Italy","Germany","Belgium"),]
proj4string(shape_bv)

bv  <- matrix(NA, nrow(tab), 1, dimnames=list(tab$id_operation, "bv"))
for (i in 1:length(shape_bv)) {
		bv[point.in.polygon(long_station, lat_station, shape_bv@polygons[[i]]@Polygons[[1]]@coords[,1], shape_bv@polygons[[i]]@Polygons[[1]]@coords[,2]) > 0,] <- as.character(shape_bv$BASIN)[i]
}
length(bv)

# les projections correspondent bien à celle des points
plot(newmap, xlim =c(-5,10), ylim = c(44,48.5),xlab="Longitude (°)",ylab="Latitude (°)")
points(long_station, lat_station, las=1, col=c("blue","lightblue")[(tab$long_station_lmbrt93==0)+1])
plot(shape_eco, border="forestgreen", add=T)
plot(shape_bv, border="limegreen", add=T)


# maintenant il faut tout remettre dans le meme tableau
tab <- data.frame(tab, long_station, lat_station, ecoregion, bv)
# sortir les anciennes colonnes
#tab <- tab[, !colnames(tab) %in% c("long_station_lmbrt93","lat_station_lmbrt93","long_lmbrtII","lat_lmbrtII")]

write.table(tab, "data/resultats peches/tableau_complet_peches.csv", row.names=F, sep=";", dec=".")

# Ajout des UH



