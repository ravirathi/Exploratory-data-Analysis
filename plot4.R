# Loading dplyr package
#library(dplyr)

nei <- readRDS("summarySCC_PM25.rds")
NEI <- tbl_df(nei)

scc <- readRDS("Source_Classification_Code.rds")
SCC <- tbl_df(scc)

SCC_Coal <- SCC[grepl("coal",SCC$Short.Name, ignore.case = TRUE),]

NEI_SCC <- merge(NEI, SCC_Coal, by = "SCC")
NEISCC <- tbl_df(NEI_SCC)

# Grouping the data by year so that it can be later used for aggregating emission by year 
by_year <- group_by(select(NEISCC,year, Emissions),year)

EmDet <- summarise(by_year, TotEm = sum(Emissions)/1000)

png("plot4.png", width = 480, height = 480)

barplot(EmDet$TotEm, names.arg=EmDet$year, 
         main=expression('Total Emission(Coal combustion) of PM'[2.5]),
         xlab='Year', ylab=expression(paste('PM', ''[2.5], ' in Kilotons')))
 
dev.off()
