## if .rda file does not exist, download it
if (!file.exists('./data/household_power_consumption_feb.Rda')) {
    ## if data/ does not exist, create it
    if (!file.exists('./data')) {
        dir.create('./data')
    }
    ## if zip file does not exist, download it
    if (!file.exists('./data/household_power_consumption.zip')) {
      download.file('http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', 
                    './data/household_power_consumption.zip')      
    }
    
    ## read from zip file
    data <- read.table(unz('./data/household_power_consumption.zip', 'household_power_consumption.txt'), sep=';', header=TRUE)

    ## Format date time
    data$DateTime <- strptime(paste(data$Date,data$Time, sep = ' '), '%d/%m/%Y %H:%M:%S')
    data$Date = as.Date(data$Date, format='%d/%m/%Y')

    ## Subset data
    febData <- subset(
        data, 
        Date >= as.Date('2007-02-01') & Date < as.Date('2007-02-03'))

    ## write to disk
    saveRDS(febData, './data/household_power_consumption_feb.Rda')
}

## load feb Data
febData <- readRDS(file='./data/household_power_consumption_feb.Rda')

## cast to numeric
febData$Global_active_power <- as.numeric(as.character(febData$Global_active_power))
febData$Global_reactive_power <- as.numeric(as.character(febData$Global_reactive_power))
febData$Sub_metering_1 <- as.numeric(as.character(febData$Sub_metering_1))
febData$Sub_metering_2 <- as.numeric(as.character(febData$Sub_metering_2))
febData$Sub_metering_3 <- as.numeric(as.character(febData$Sub_metering_3))
febData$Voltage <- as.numeric(as.character(febData$Voltage))

## Plot
png('plot4.png', width=480, height=480, units='px')
par(mfrow=c(2,2))
with(febData, {
  plot(DateTime, Global_active_power, type='l', xlab='', ylab='Global Active Power (kilowatts)')
  
  plot(DateTime, Voltage, type='l', xlab='datetime', ylab='Voltage')
  
  plot(DateTime, Sub_metering_1, type='l', xlab='', ylab='Energy sub metering')
  lines(DateTime, Sub_metering_2, type='l', col='red')
  lines(DateTime, Sub_metering_3, type='l', col='blue')
  legend('topright', 
         c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), 
         lty=c(1,1,1), 
         col=c('black', 'red', 'blue'), bty='n') 
  
  plot(DateTime, Global_reactive_power, type='l', xlab='datetime', ylab='Global_reactive_power')
  
})

dev.off()

