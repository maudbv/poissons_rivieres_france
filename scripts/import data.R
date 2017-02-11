# Import data sets
library(readxl)
library(plyr)

Sys.setlocale("LC_ALL", 'UTF-8')

# fishing data "Exploitation"
# fishing data files "Exploitation_REGION_ANNEES" contain fish abundances by species, date, coordinates and fishing mode and method. Exploitation files contain additional information such as river name and the aim of the fishing ("Etude" or "RHP"). They are not necessary for now.

### Resultats peches
peches <- read_excel("data/resultats peches/fichiers bruts/Exploitation_Alsace_2010-2013.xls", 
                     sheet = 2)
peches$`Date de pêche` <- as.Date(peches$`Date de pêche`)

colnames(peches)

# loading several files at once
noms_colonnes <- read.csv("data/lexicon/colnames_resultats_peches_PC.csv",
	encoding = "native.enc", sep=";", h=T)
for (i in 1:ncol(noms_colonnes)) noms_colonnes[,i] <- as.character(noms_colonnes[,i])
# list of the files to include
lst <- paste("data/resultats peches/fichiers bruts", list.files("data/resultats peches/fichiers_bruts"), sep = "")
nrow_count <- matrix(numeric(), length(lst), 1, dimnames=list(lst, "count"))
colnames_test <- matrix(logical(), length(lst), 1, dimnames=list(lst, "tst"))

#loading function that has to change colnames before rbinding
read.xls <- function(path_name, sheet) {
	tmp <- read_excel(path=path_name, sheet=sheet)
	if(any(colnames(tmp) != noms_colonnes$old.name)) { # si les noms sont différents
		colnames_test[path_name, 1] <<- FALSE
	} else {
		colnames_test[path_name, 1] <<- TRUE
		colnames(tmp) <- noms_colonnes$corrected.name
		nrow_count[path_name, 1] <<- nrow(tmp)
	}
	tmp
}


tab <- ldply(lst, read.xls, sheet=2, .progress="text")
tab$date <- as.Date(tab$date)

# verifications
if (nrow(tab) != sum(nrow_count)) warning()
if (any(!colnames_test)) warning()
 # verification of date format?
table(tab$long_lmbrtII>tab$lat_lmbrtII)	# verification that mislabelled columns (i.e. ordonnée Lambert II + ordonnée Lambert II) are allways in the order X then Y.
if (any(tab$long_lmbrtII>tab$lat_lmbrtII)) warning()
tab[sample(x=1:nrow(tab), size=10, replace=F),] # homogeneity

# vérifier qu'il n'y ait pas de NA dans les noms de stations

# saving
write.table(tab, "data/resultats peches/tableau_complet_peches.csv", sep=";", dec=".", row.names=F)


# fish size class data

# data from stations (Environment)


