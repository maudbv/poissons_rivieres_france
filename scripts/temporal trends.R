library("TraMineR")
load("data/resultats peches/ab_brut")

# Analyse the number of stations with complete temporal trends, for how long.
annual_captures <- apply(ab, c(1,3), sum, na.rm=T)
species_captures_mean <- apply(ab, c(3,2), mean, na.rm=T)
species_captures_sd <- apply(ab, c(3,2), sd, na.rm=T)
apply(annual_captures, 1, function(x)

annual_captures[annual_captures>0] <- 1

cnt_tot <- matrix(0, nrow(annual_captures), 4)
for (ope in 1:nrow(annual_captures)) {
cnt <- 1
	for (year in 2:ncol(annual_captures)) {
		if(annual_captures[ope, year-1]==1)	{
			 if(annual_captures[ope, year]==1) {
				cnt_tot[ope, cnt] <- cnt_tot[ope, cnt] + 1
			} else {
				cnt <- cnt + 1
			}
		}
		if(annual_captures[ope, year-1]==0)	{
			 if(annual_captures[ope, year]==1) {
				cnt_tot[ope, cnt] <- cnt_tot[ope, cnt] + 1
			} else {
				# rien ?
			}
		}
	}
}




tst <- annual_captures
tmp <- seqformat(data=annual_captures, from="STS", to="SPS")
tmpp <- seqdef(data=annual_captures, from="STS", to="SPS")

