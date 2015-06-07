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

#filter to baltimore data
baltimore <- NEI[NEI$fips == "24510",]

# aggregate total emissions by year
baltimoreTotals <- aggregate(Emissions~year, data=baltimore, sum)

#set device to png device
png(filename = "plot2.png", width=480, height=480, bg = "transparent")
# construct plot
plot(baltimoreTotals$year, baltimoreTotals$Emissions, type = "l",
     main = 'Total PM2.5 Emissions in Baltimore City 1999-2008',
     ylab = 'Total PM2.5 Emissions (tons)',
     xlab = 'Year')
# turn off device
dev.off()
