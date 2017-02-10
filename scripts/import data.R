# Import data sets
library(readxl)
library(plyr)

Sys.setlocale("LC_ALL", 'UTF-8')

# fishing data "Exploitation"
# fishing data files "Exploitation_REGION_ANNEES" contain fish abundances by species, date, coordinates and fishing mode and method. Exploitation files contain additional information such as river name and the aim of the fishing ("Etude" or "RHP"). They are not necessary for now.

### Resultats peches
peches <- read_excel("data/resultats peches/Exploitation_Alsace_2010-2013.xls", 
                     sheet = 2)
peches$`Date de pêche` <- as.Date(peches$`Date de pêche`)

colnames(peches)

# pour charger plusieurs fichier à la fois
lst <- paste("data/resultats peches/", list.files("data/resultats peches"), sep = "")

tab <- llply(lst, read_excel, sheet=2) # ca c'est beau mais ça ne marche que si tous les fichiers source ont les mêmes noms de colonnes...

lapply(tab, function(x) match(colnames(x), colnames(tab[[1]])))

# changement des noms de colonnes

read.table("data/lexicon/colnames_resultats_peches.txt", encoding = "native.enc" )
read.table("data/lexicon/Untitled.txt", encoding = "UTF-8" )




# # corriger les
# peches$`Date de pêche` <- as.Date(peches$`Date de pêche`) 
# 

# fish size class data

# data from stations (Environment)


