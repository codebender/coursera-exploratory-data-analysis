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

#filter to baltimore data
baltimore <- NEI[NEI$fips == "24510",]

# aggregate total emissions by year and type
baltimoreTotals <- aggregate(Emissions~year+type, data=baltimore, sum)

# transform year into factor
baltimoreTotals$year <- factor(baltimoreTotals$year)

#set device to png device
png(filename = "plot3.png", width=960, height=480, bg = "transparent")
# construct plot
plot <- ggplot(baltimoreTotals, aes(x=year, y=Emissions, fill=type)) +
  geom_bar(stat="identity") +
  facet_grid(. ~ type) +
  labs(title = "Total PM2.5 Emissions by type in Baltimore City 1999-2008",
    x = "Year", y = "Total PM2.5 Emissions (tons)")
print(plot)
# turn off device
dev.off()
