#import data
tab <- read.table("data/resultats peches/tableau_complet_peches.csv", sep=";", dec=".", h=T)
tab$date <- as.Date(tab$date)
tab <- data.frame(year=substr(tab$date, 1, 4), tab)
lst_sp <- unique(tab$code_espece)
lst_ope <- unique(tab$code_onema)
length(lst_sp)
length(lst_ope)

# For now, all fishing occasions for a single station are taken into account.
ab_brut <- xtabs(formula=nb_ind ~ code_onema + code_espece + year, data=tab, drop.unused.levels=T)
biomass_brut <- xtabs(formula=masse_ind ~ code_onema + code_espece + year, data=tab, drop.unused.levels=T)

ab_stand <- xtabs(formula=densite_ind ~ code_onema + code_espece + year, data=tab, drop.unused.levels=T)
biomass_stand <- xtabs(formula=densite_masse ~ code_onema + code_espece + year, data=tab, drop.unused.levels=T)

# verification of the standardisation used
any(tab$nb_ind/tab$surface*100 != tab$densite_ind) # there are differences but it may just be rounding errors
cor((tab$nb_ind/tab$surface*100)[!is.na(tab$surface)], tab$densite_ind[!is.na(tab$surface)], method="sp")
plot((tab$nb_ind/tab$surface*100)[!is.na(tab$surface)], tab$densite_ind[!is.na(tab$surface)])

sum(is.na(tab$nb_ind/tab$surface))
sum(is.na(tab$nb_ind))
sum(is.na(tab$densite_ind))

# is the surface the same every year? Nope, it is measured "every" time
tapply(tab$surface, tab$code_onema, function(x) length(unique(x))) # 1 to 13 measures by station
tab[as.character(tab$code_onema)=="06730213" & !is.na(tab$code_onema),] # example


# correction for the capturability of species



save(ab_brut, file="data/resultats peches/ab_brut")


