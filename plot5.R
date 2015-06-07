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

#filter SCC to vehicle data
vehicleSCCData <- SCC[grep("Vehicle",SCC$EI.Sector),]

#filter NEI to vehicle data
baltimore <- NEI[NEI$fips == "24510",]
baltimoreVehicleNEI <- baltimore[(baltimore$SCC %in% vehicleSCCData$SCC),]

# aggregate total emissions by year
baltimoreVehicleTotals <- aggregate(Emissions~year, data=baltimoreVehicleNEI, sum)

#set device to png device
png(filename = "plot5.png", width=480, height=480, bg = "transparent")
# construct plot
plot <- ggplot(baltimoreVehicleTotals,
               aes(x=factor(year), y=Emissions, fill = Emissions)) +
  geom_bar(stat="identity") +
  scale_fill_gradient("Count", low = "green", high = "red") +
  labs(title = "Total PM2.5 Vehicle Emissions in Baltimore City 1999-2008",
    x = "Year", y = "Total PM2.5 Vehicle Emissions (tons)")
print(plot)
# turn off device
dev.off()
