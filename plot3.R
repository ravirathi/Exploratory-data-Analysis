# Loading dplyr package
library(dplyr)
install.packages("ggplot2")

nei <- readRDS("summarySCC_PM25.rds")
NEI <- tbl_df(nei)

NEI_Baltimore <- filter(NEI, fips == 24510)

# Grouping the data by year so that it can be later used for aggregating emission by year 
by_year <- group_by(select(NEI_Baltimore,year, type, Emissions),year, type)

EmDet <- summarise(by_year, TotEm = sum(Emissions))

png("plot3.png", width = 480, height = 480)

ggplot(EmDet, aes(year,TotEm))+ geom_point() + geom_line(aes(color = factor(type))) +ggtitle('Emissions per Type in Baltimore City, Maryland') +ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) +scale_x_continuous(breaks= c(1999, 2002, 2005, 2008))
 
dev.off()
