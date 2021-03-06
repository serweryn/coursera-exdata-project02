# load datasets only if they aren't already loaded
if (!exists("NEI")) {
  NEI <- readRDS("summarySCC_PM25.rds")
}
if (!exists("SCC")) {
  SCC <- readRDS("Source_Classification_Code.rds")
}

library(plyr) # required for ddply

# aggreate emmissions over years
aggEmissions <- ddply(NEI, ~year, summarise, Emissions=sum(Emissions))

png(file = "plot1.png", width = 480, height = 480)

# plot emissions over years
barplot(aggEmissions$Emissions, names.arg=aggEmissions$year,
        main="PM2.5 Emissions in US", xlab="Year", ylab="Emissions in year [tons]")

dev.off()
