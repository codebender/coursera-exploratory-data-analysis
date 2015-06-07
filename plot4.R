# load dependency 
library(ggplot2)

# Read data
data_dir = 'exdata-data-NEI_data'

if(dir.exists(data_dir)) {
  if(!exists("NEI")) {
    NEI <- readRDS(paste(data_dir, "summarySCC_PM25.rds", sep = "/"))
  }
  if(!exists("SCC")) {
    SCC <- readRDS(paste(data_dir, "Source_Classification_Code.rds", sep = "/"))
  }
} else {
  stop('missing rds data files')
}

#filter SCC to coal data
coalSCCData <- SCC[grep("Coal",SCC$EI.Sector),]

#filter NEI to coal data
coalNEIData <- NEI[NEI$SCC %in% coalSCCData$SCC,]

# aggregate total emissions by year
coalTotals <- aggregate(Emissions~year, data=coalNEIData, sum)

#set device to png device
png(filename = "plot4.png", width=480, height=480, bg = "transparent")
# construct plot
plot <- ggplot(coalTotals, aes(x=factor(year), y=Emissions, fill = Emissions)) +
  geom_bar(stat="identity") +
  scale_fill_gradient("Count", low = "orange", high = "red") +
  labs(title = "Total PM2.5 Coal Emissions in United States 1999-2008",
    x = "Year", y = "Total PM2.5 Coal Emissions (tons)")
print(plot)
# turn off device
dev.off()
