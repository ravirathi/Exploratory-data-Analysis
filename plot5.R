# Loading dplyr package
library(dplyr)

nei <- readRDS("summarySCC_PM25.rds")
NEI <- tbl_df(nei)

scc <- readRDS("Source_Classification_Code.rds")
SCC <- tbl_df(scc)

SCC_Vehicle <- SCC[grepl("vehicle",SCC$SCC.Level.Two, ignore.case = TRUE),]

NEI_SCC <- merge(NEI, SCC_Vehicle, by = "SCC")
NEISCC <- tbl_df(NEI_SCC)

NEISCC_Baltimore <- filter(NEISCC, fips == 24510)

# Grouping the data by year so that it can be later used for aggregating emission by year 
by_year <- group_by(select(NEISCC_Baltimore,year, Pollutant, Emissions),year, Pollutant)

EmDet <- summarise(by_year, TotEm = sum(Emissions))

png("Proj2_plot5.png", width = 480, height = 480)
barplot(EmDet$TotEm, names.arg=EmDet$year, 
        main=expression('Total Emission(Baltimore) by Motor Vehicle of PM'[2.5]),
        xlab='Year', ylab=expression(paste('PM', ''[2.5], ' in Kilotons')))

dev.off()