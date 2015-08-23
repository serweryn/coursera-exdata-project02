# load datasets only if they aren't already loaded
if (!exists("NEI")) {
  NEI <- readRDS("summarySCC_PM25.rds")
}
if (!exists("SCC")) {
  SCC <- readRDS("Source_Classification_Code.rds")
}

library(plyr) # required for ddply

# filter NEI data for Baltimore
neiBaltimore <- NEI[NEI$fips == 24510,]
# aggreate emmissions over years
aggEmissions <- ddply(neiBaltimore, ~year, summarise, Emissions=sum(Emissions))

png(file = "plot2.png", width = 480, height = 480)

# plot emissions over years
plot(aggEmissions$year, aggEmissions$Emissions, type="h", lwd=5, col="red",
     main="PM2.5 Emissions in Baltimore City, Maryland", xlab="Year", ylab="Emissions in year")

dev.off()
