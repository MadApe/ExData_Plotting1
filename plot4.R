# load libraries
library(data.table)


# initialize source and destination variables of the data files
wd <- getwd()
data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
data_dir <- file.path(wd, "data/")
data_zip <- file.path(data_dir, "household_power_consumption.zip")
data_txt <- file.path(data_dir, "household_power_consumption.txt")
plot_png <- file.path(wd, "plot4.png")

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

# create a vector of datetimes by pasting the Date and Time fields together and converting using strptime
datetimes <- with(power_dt, strptime(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S"))

# bind the datetimes column to the power_dt data table
power_dt <- cbind(datetimes, power_dt)

# open the PNG Graphic Device and set the size
cat("Plotting the data...\n")
png(plot_png, units = "px", width = 480, height = 480)

# setup the plot area to hold two columns and two rows of plots; apply some margins
par(mfrow=c(2,2), mar=c(4,4,2,1))

# Plot 1 (upper left)
with(power_dt, plot(Global_active_power~datetimes, type="l", xlab="", ylab="Global Active Power"))

# Plot 2 (upper right)
with(power_dt, plot(Voltage~datetimes, type="l", xlab="datetime", ylab="Voltage"))

# Plot 3 (lower left)
with(power_dt, plot(Sub_metering_1~datetimes, type = "l", xlab = "", ylab = "Energy sub metering"))
with(power_dt, lines(Sub_metering_2~datetimes, type = "l", col = "red"))
with(power_dt, lines(Sub_metering_3~datetimes, type = "l", col = "blue"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1)

# Plot 4 (lower right)
with(power_dt, plot(Global_reactive_power~datetimes, type="l", xlab="datetime", ylab="Global_reactive_power"))

# close the PNG graphic device
dev.off()

cat("Complete!\nPlot file located at: ", plot_png, "\n", sep = "")

