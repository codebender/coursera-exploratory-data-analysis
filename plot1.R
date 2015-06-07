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

# aggregate total emissions by year
yearTotals <- aggregate(NEI$Emissions, list(year = NEI$year), sum)

#set device to png device
png(filename = "plot1.png", width=480, height=480, bg = "transparent")
# construct plot
plot(yearTotals$year, yearTotals$x, type = "l",
     main = 'Total PM2.5 Emissions in United States 1999-2008',
     ylab = 'Total PM2.5 Emissions (tons)',
     xlab = 'Year')
# turn off device
dev.off()
