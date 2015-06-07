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

YoYPercentageChange <- function (x) {
  c(0,100*diff(x)/x[-length(x)])
}

getFipsVehicleNEI <- function(fips) {
  #filter NEI to vehicle data
  fipsNEI <- NEI[NEI$fips == fips,]
  fipsVehicleNEI <- fipsNEI[(fipsNEI$SCC %in% vehicleSCCData$SCC),]
  # aggregate total emissions by year
  fipsVehicleTotals <- aggregate(Emissions~year, data=fipsVehicleNEI, sum)
  # calculate Year to year change
  fipsVehicleTotals$YoYPercentageChange <- YoYPercentageChange(fipsVehicleTotals$Emissions)
  fipsVehicleTotals$YoY <- paste(fipsVehicleTotals$year-3, fipsVehicleTotals$year, sep = "-")
  fipsVehicleTotals[2:nrow(fipsVehicleTotals),]
}

# Get fips based vehicle data
baltimoreVehicleEmissions <- getFipsVehicleNEI("24510")
baltimoreVehicleEmissions$City <- "Baltimore City (fips = 24510)"
losAngelesVehicleEmissions <- getFipsVehicleNEI("06037")
losAngelesVehicleEmissions$City <- "Los Angeles County (fips = 06037)"

fipsData <- rbind(baltimoreVehicleEmissions, losAngelesVehicleEmissions)

#set device to png device
png(filename = "plot6.png", width=960, height=480)
# construct plot
plot <- ggplot(fipsData, aes(x=factor(YoY), y=YoYPercentageChange, fill = YoYPercentageChange)) +
  ylim(-100, 100) +
  geom_bar(stat="identity") +
  facet_grid(. ~ City) +
  labs(title = "Year over Year % Change of Total PM2.5 Vehicle Emissions in Baltimore City vs Los Angeles County from 1999-2008",
    x = "Year", y = "YoY Change in 2.5M Emissions (%)") +
  theme(legend.title=element_blank())
print(plot)
# turn off device
dev.off()
