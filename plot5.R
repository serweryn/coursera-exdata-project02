# load datasets only if they aren't already loaded
if (!exists("NEI")) {
  NEI <- readRDS("summarySCC_PM25.rds")
}
if (!exists("SCC")) {
  SCC <- readRDS("Source_Classification_Code.rds")
}

library(ggplot2)
library(plyr) # required for ddply

# select only SCCs which are vehicle related -- using grep to find proper row indices
sccOfInterest <- SCC[grep("Vehicle", SCC$EI.Sector),]
# select only measures from vehicle related SCCs
neiOfInterest <- NEI[NEI$SCC %in% sccOfInterest$SCC,]

# filter NEI data for Baltimore
neiOfInterest <- neiOfInterest[neiOfInterest$fips == 24510,]

# merge data frames for easier aggregation on EI.Sector
merged <- merge(neiOfInterest, sccOfInterest, by.x="SCC", by.y="SCC")

# aggreate emmissions over years, for each source and for all of them
aggPerSource <- ddply(merged, ~year+EI.Sector, summarise, Emissions=sum(Emissions))
aggAll <- ddply(aggPerSource, ~year, summarise, Emissions=sum(Emissions))
aggEmissions <- rbind(aggPerSource, data.frame(year=aggAll$year, EI.Sector="All", Emissions=aggAll$Emissions))

# shorten labels to fit them on plots
aggEmissions$EI.Sector <- gsub("Mobile - On-Road ", "", aggEmissions$EI.Sector)

png(file = "plot5.png", width = 960, height = 360)

plot <- qplot(year, Emissions, data=aggEmissions, facets=.~EI.Sector,
              main="PM2.5 emissions from motor vehicle sources (Baltimore City, Maryland)", 
              xlab="Year", ylab="Emissions in year [tons]")
print(plot)

dev.off()
