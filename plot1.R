if (!exists("NEI")) {
  NEI <- readRDS("summarySCC_PM25.rds")
}

if (!exists("SCC")) {
  SCC <- readRDS("Source_Classification_Code.rds")
}

library(plyr)

aggEmissions <- ddply(NEI, ~year, summarise, Emissions=sum(Emissions))

png(file = "plot1.png", width = 480, height = 480)

plot(aggEmissions$year, aggEmissions$Emissions, type="h", lwd=5, col="red",
     main="PM2.5 Emissions in US", xlab="Year", ylab="Emissions")

dev.off()
