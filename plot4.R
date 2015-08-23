# load datasets only if they aren't already loaded
if (!exists("NEI")) {
  NEI <- readRDS("summarySCC_PM25.rds")
}
if (!exists("SCC")) {
  SCC <- readRDS("Source_Classification_Code.rds")
}

library(ggplot2)
library(plyr) # required for ddply

# select only SCCs which are coal combustion related -- using grep to find proper row indices
sccOfInterest <- SCC[grep("Comb.*Coal", SCC$EI.Sector),]
# select only measures from coal combustion-related SCCs
neiCombustionCoal <- NEI[NEI$SCC %in% sccOfInterest$SCC,]

# merge data frames for easier aggregation on EI.Sector
merged <- merge(neiCombustionCoal, sccOfInterest, by.x="SCC", by.y="SCC")

# aggreate emmissions over years, for each source and for all of them
aggPerSource <- ddply(merged, ~year+EI.Sector, summarise, Emissions=sum(Emissions))
aggAll <- ddply(aggPerSource, ~year, summarise, Emissions=sum(Emissions))
aggEmissions <- rbind(aggPerSource, data.frame(year=aggAll$year, EI.Sector="All", Emissions=aggAll$Emissions))

png(file = "plot4.png", width = 960, height = 480)

# make plot for each coal combustion-related source and all of them
plot <- qplot(year, Emissions, data=aggEmissions, facets=.~EI.Sector,
              main="PM2.5 emissions in US from coal combustion-related sources", 
              xlab="Year", ylab="Emissions in year [tons]")
print(plot)

dev.off()
