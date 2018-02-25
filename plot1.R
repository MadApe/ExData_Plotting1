# load libraries
library(data.table)


# initialize source and destination variables of the data files
wd <- getwd()
data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
data_dir <- file.path(wd, "data/")
data_zip <- file.path(data_dir, "household_power_consumption.zip")
data_txt <- file.path(data_dir, "household_power_consumption.txt")
plot_png <- file.path(wd, "plot1.png")

# initialize the observation start/end date variables
observation_start <- strptime("01/02/2007", "%d/%m/%Y")
observation_end <- strptime("02/02/2007", "%d/%m/%Y")

# create a directory for the data if one doesn't exist
if (!file.exists(data_dir)) {
  dir.create(data_dir)
}

# download the data file if it isn't already there
if (!file.exists(data_zip)) {
  cat("Downloading data zip file ...\n")
  download_date <- Sys.time()
  download.file(data_url, data_zip)
}

# unzip the file if the download is there and hasn't been unzipped
if (file.exists(data_zip) & !file.exists(data_txt)) {
  cat("Unzipping the data zip file ...\n")
  unzip(zipfile = data_zip, exdir = data_dir)
}

# read the file into a data.table
cat("Reading the data...\n")
dt <- fread(data_txt, header = TRUE, na.strings = "?", stringsAsFactors = FALSE)

# subset the data.table to include only the date range in which we are interested
cat("Subsetting the data...\n")
power_dt <- subset(dt, strptime(Date, "%d/%m/%Y") >= observation_start & strptime(Date, "%d/%m/%Y") <= observation_end)

# open the PNG Graphic Device and set the size
cat("Plotting the data...\n")
png(plot_png, units = "px", width = 480, height = 480)

# create a histogram of Global Active Power and set title, x-axis label, and color
hist(power_dt$Global_active_power, 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", 
     col = "red")

# close the PNG graphic device
dev.off()

cat("Complete!\nPlot file located at: ", plot_png, "\n", sep = "")

