# Import data sets 
library(readxl)
peches <- read_excel("data/resultats peches/Exploitation_Alsace_2010-2013.xls", 
                      sheet = 2)
peches$`Date de pêche` <- as.Date(peches$`Date de pêche`)


# Coordinate conversion

library(rgdal)
# les coordonnées des stations sont en Lambert93 ou en LambertII.
# pour les coordonnées en Lambert93, pas de problème
spatial93 <- data.frame(X=peches$'Abscisse Station(Lambert 93)', Y=peches$'Ordonnée Station(Lambert 93)')
coordinates(spatial93) <- ~X + Y
proj4string(spatial93) <- CRS("+init=epsg:2154") # définition du référentiel
#2154 pour Lambert93, 27571 à 2754 pour Lambert I à IV cf. make_EPSG() (package rgdal)
spatial93 <- spTransform (spatial93, CRS("+proj=longlat +ellps=WGS84"))
spatial93 <- data.frame(spatial93)

# pour les coordonnées en LambertII, les deux colonnes s'appellent "Ordonnée", c'est moche...
# il faudra aussi faire attention au Lambert à utiliser selon la région
spatialII <- data.frame(X=peches$'Ordonnée (Lambert II)', Y=peches[,which(colnames(peches)=='Ordonnée (Lambert II)')[2]])
coordinates(spatialII) <- ~X + Y
proj4string(spatialII) <- CRS("+init=epsg:27572") # définition du référentiel
spatialII <- spTransform (spatialII, CRS("+proj=longlat +ellps=WGS84"))
spatialII <- data.frame(spatialII)

X <- spatial93$X
X[peches$'Abscisse Station(Lambert 93)'==0] <- spatialII[peches$'Abscisse Station(Lambert 93)'==0, "X"]

Y <- spatial93$Y
Y[peches$'Abscisse Station(Lambert 93)'==0] <- spatialII[peches$'Abscisse Station(Lambert 93)'==0, "Y"]

#Verification
library(rworldmap)
newmap <- getMap(resolution = "low")
plot(newmap, xlim =c(-5,10), ylim = c(44,48.5),xlab="Longitude (°)",ylab="Latitude (°)")
points(X, Y, las=1, col=c("blue","lightblue")[(peches$'Abscisse Station(Lambert 93)'==0)+1])
# les points sont bien en Alsace et les deux types de projection semblent bien correspondrent.





# Ecozones
# Ecoregions, watershed (CCMC2)...

#Ecoregions Illies
shape_eco <- readOGR(dsn="data/sig/ecoregions" ,layer="Ecoregions") # Illies ecoregions
proj4string(shape_eco)
shape_eco <- spTransform(shape_eco, CRS("+proj=longlat +datum=WGS84")) # re projection des coordonnées
proj4string(shape_eco)
shape_eco$AREA_ID <- as.factor(shape_eco$AREA_ID)

ecoregion  <- matrix(NA, nrow(peches), 1, dimnames=list(peches$"Numéro de l'opération", "ecoregion"))
for (i in 1:length(shape_eco)) { # 12 et 15
		ecoregion[point.in.polygon(X, Y, shape_eco@polygons[[i]]@Polygons[[1]]@coords[,1], shape_eco@polygons[[i]]@Polygons[[1]]@coords[,2]) > 0,] <- as.character(shape_eco$NAME)[i]
}


# Bassins versants
shape_bv <- readOGR(dsn="data/sig/bassins_versants" ,layer="BassinEurope") # bassins_versants
shape_bv <- shape_bv[shape_bv$Country %in% c("France","Spain","Italy","Germany","Belgium"),]
proj4string(shape_bv)

bv  <- matrix(NA, nrow(peches), 1, dimnames=list(peches$"Numéro de l'opération", "bv"))
for (i in 1:length(shape_bv)) { # 12 et 15
		bv[point.in.polygon(X, Y, shape_bv@polygons[[i]]@Polygons[[1]]@coords[,1], shape_bv@polygons[[i]]@Polygons[[1]]@coords[,2]) > 0,] <- as.character(shape_bv$BASIN)[i]
}


# les projections correspondent bien à celle des points
plot(newmap, xlim =c(-5,10), ylim = c(44,48.5),xlab="Longitude (°)",ylab="Latitude (°)")
points(X, Y, las=1, col=c("blue","lightblue")[(peches$'Abscisse Station(Lambert 93)'==0)+1])
plot(shape_eco, border="forestgreen", add=T)
plot(shape_bv, border="limegreen", add=T)



# maintenant il faut tout remettre dans le meme tableau
# sortir les anciennes colonnes
# changer tous les noms de colonnes pourris de l'ONEMA...

