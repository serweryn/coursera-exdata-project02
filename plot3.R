# load datasets only if they aren't already loaded
if (!exists("NEI")) {
  NEI <- readRDS("summarySCC_PM25.rds")
}
if (!exists("SCC")) {
  SCC <- readRDS("Source_Classification_Code.rds")
}

library(ggplot2)
library(plyr) # required for ddply

# filter NEI data for Baltimore
neiBaltimore <- NEI[NEI$fips == 24510,]

# aggreate emmissions over years and source types
aggEmissions <- ddply(neiBaltimore, ~year + type, summarise, Emissions=sum(Emissions))

png(file = "plot3.png", width = 960, height = 360)

# make plot for each 4 source types
plot <- qplot(year, Emissions, data=aggEmissions, facets=.~type,
              main="PM2.5 emissions per source type (Baltimore City, Maryland)", 
              xlab="Year", ylab="Emissions in year")
print(plot)

dev.off()
