library("TraMineR")
library("plyr")
load("data/resultats peches/ab_brut")

# Analyse the number of stations with complete temporal trends, for how long.
annual_captures <- apply(ab, c(1,3), sum, na.rm=T)
annual_captures[annual_captures > 0] <- 1

tmp <- seqdef(data=annual_captures, informat="STS", cpal=c("#BEAED4", "#7FC97F"))
alphabet(tmp)
cpal(tmp) # colors of both categories
stlab(tmp) <- c("no-fishing","fishing")

seqstatd(tmp) # by-year summary
seqmodst(tmp) # by-year mean/frequency

seqlength(tmp)
seqdss(tmp) # state sequence of each sequence/site
seqdur(tmp) # duration of each sequence
seqsubsn(tmp) # number of subsequences (?)
seqistatd(tmp) # by-site sums
seqstatd(tmp) # by-year summary

state <- seqdss(tmp)
dur <- seqdur(tmp)
state_split <- as.data.frame(aaply(state, c(1,2), function(x) as.numeric(strsplit(as.character(x), split="-")), .progress="text"))
state_split[state_split==4] <- NA
state_split[state_split==1] <- 0
state_split[state_split==2] <- 1
rownames(state_split) <- rownames(state)

tst <- array(data=c(unlist(state_split),c(dur)), dim=c(dim(dur),2),
	dimnames=list(rownames(state_split), c(), c("state_split","duration")))

comptage <- alply(tst, 1, function(station) station[station[,1]==1 & !is.na(station[,1]), 2]) # list of fishing sequence lengths for each site

threshold <- 1
gap_size <- 1

# Number of sites for which we have at least one sequences (>threshold)
sum(laply(comptage, function(x) any(na.omit(x) > threshold)))

# Mean duration of sequences >threshold (when more than one in a station, only max is kept)
max_duration_by_station <- function(comptage_station)  {
	tmp <- comptage_station[comptage_station > threshold & !is.na(comptage_station)]
	ifelse(length(tmp)==0, NA, ifelse(length(tmp)==1, tmp, max(tmp)))
}
mean(laply(comptage, max_duration_by_station), na.rm=T)

number_of_long_sequences_by_station <- function(comptage_station)  {
	tmp <- comptage_station[comptage_station > threshold & !is.na(comptage_station)]
	ifelse(length(tmp)==0, 0, length(tmp))
}
table(laply(comptage, number_of_long_sequences_by_station))

# Number of sequences >threshold with 1 (gap_size) year gaps (at least 1-0-1-1 or 1-1-0-1)






# "seqe-" sequences are sequences of events (events are changes of state)
temp <- seqecreate(tmp)
list_temp <- seqefsub(temp, constraint=seqeconstraint(maxGap=2, windowSize=8), minSupport=100)
seqeconstraint(maxGap=1, windowSize=28) # for setting constraints for look ups by seqeapplysub
res <- seqeapplysub(list_temp, constraint=seqeconstraint(maxGap=1, windowSize=4)) # looks for subsequences

## Looking for frequent subsequences
fsubseq <- seqefsub(temp, pMinSupport=0.01)

## Counting the number of occurrences of each subsequence
msubcount <- seqeapplysub(fsubseq, method="count", constraint=seqeconstraint(maxGap=1, windowSize=4))






# Graphic representations
seqiplot(tmp, border = NA, tlim=0, withlegend=FALSE)
seqIplot(tmp, border = NA)
seqdplot(tmp, border = NA)