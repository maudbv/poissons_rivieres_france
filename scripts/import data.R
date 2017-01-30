# Import data sets
library(readxl)

# fishing data

## eg for 2000-2009 in Alsace:
peches <- read_excel("data/resultats peches/Exploitation_Alsace_2010-2013.xls", 
                      sheet = 2)
peches$`Date de pêche` <- as.Date(peches$`Date de pêche`)
               
               
# data for each operation

# fish size class data

# data from stations
  
