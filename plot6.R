# Loading dplyr package
library(dplyr)
install.packages("ggplot2")

nei <- readRDS("summarySCC_PM25.rds")
NEI <- tbl_df(nei)

scc <- readRDS("Source_Classification_Code.rds")
SCC <- tbl_df(scc)

SCC_Vehicle <- SCC[grepl("vehicle",SCC$SCC.Level.Two, ignore.case = TRUE),]

NEI_SCC <- merge(NEI, SCC_Vehicle, by = "SCC")
NEISCC <- tbl_df(NEI_SCC)

NEISCC_Baltimore_LA <- filter(NEISCC, fips == "24510" | fips == "06037")
NEISCC_BT_LA <- mutate(NEISCC_Baltimore_LA, city = ifelse(fips == "24510","Baltimore","LA"))

# Grouping the data by year so that it can be later used for aggregating emission by year 
by_year <- group_by(select(NEISCC_BT_LA,year, fips, city, Emissions),year, fips, city)

EmDet <- summarise(by_year, TotEm = sum(Emissions))

png("Proj2_plot6.png", width = 480, height = 480)

ggplot(EmDet, aes(year,TotEm))+ geom_point() + geom_line(aes(color = factor(city))) +ggtitle('Emissions per Type in Baltimore City, Maryland') +ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) +scale_x_continuous(breaks= c(1999, 2002, 2005, 2008))

dev.off()