# Loading dplyr package
library(dplyr)

nei <- readRDS("summarySCC_PM25.rds")
NEI <- tbl_df(nei)

# Grouping the data by year so that it can be later used for aggregating emission by year 
by_year <- group_by(select(NEI,year, Pollutant, Emissions),year, Pollutant)

EmDet <- summarise(by_year, TotEm = sum(Emissions)/1000)

png("plot1.png", width = 480, height = 480)
barplot(EmDet$TotEm, names.arg=EmDet$year, 
         main=expression('Total Emission of PM'[2.5]),
         xlab='Year', ylab=expression(paste('PM', ''[2.5], ' in Kilotons')))
 
dev.off()


