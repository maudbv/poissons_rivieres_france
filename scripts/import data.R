# Import data sets
library(readxl)
library(plyr)
# fishing data "Exploitation"
# fishing data files "Exploitation_REGION_ANNEES" contain fish abundances by species, date, coordinates and fishing mode and method. Exploitation files contain additional information such as river name and the aim of the fishing ("Etude" or "RHP"). They are not necessary for now.

## eg for 2000-2009 in Alsace:
peches <- read_excel("data/resultats peches/Exploitation_Alsace_2010-2013.xls", 
                      sheet = 2)
peches$`Date de pêche` <- as.Date(peches$`Date de pêche`)
              
# pour charger plusieurs fichier à la fois
setwd("C:/Users/Alban/Recherche/poissons_rivieres_france/data/resultats peches/")
lst <- list.files()
tab <- ldply(lst, read_excel, sheet=2) # ca c'est beau mais ça ne marche que si tous les fichiers source ont les mêmes noms de colonnes...

# changement des noms de colonnes
anciens_noms <- c("Date de pêche", "Code station Sandre" , "Code station Onema",
	"Localisation", "Abscisse Station(Lambert 93)", "Ordonnée Station(Lambert 93)",
	"Ordonnée (Lambert II)", "Abscisse Point(Lambert 93)", "Numéro de l'opération",
	"Département",  "Code Insee", "Nom de la commune",  
	"Code hydrographique générique du cours d'eau", "Nom usuel du cours d'eau", "Surface m²",
	"Nom usuel de l'espèce", "Code Onema de l 'espèce", "Effectif (ind.)", 
	"Masse (g)", "Densite en nombre(ind./100 m²)" ,"Densité en masse (g/100 m²)",
	"Nombre de passage", "Methode de Prospection", "Moyen de Prospection")

nouveaux_noms <- c("date","code_sandre","code_onema",
	"localisation","long_station_lmbrt93","lat_station_lmbrt93",
	"long_lmbrtII","lat_lmbrtII","long_point_lmbrt93","lat_point_lmbrt93","id_operation",
	"departement","code_insee","commune",
	"code_hydro_riviere","nom_riviere","surface",
	"nom_espece","code_espece","nb_ind",
	"masse_ind","densite_ind","densite_masse",
	"nb_passage","methode_prospection","moyen_prospection")
# fish size class data

# data from stations (Environment)


