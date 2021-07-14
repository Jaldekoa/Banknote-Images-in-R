# Load the required libraries
require("jpeg")
require("grid")
require("ggplot2")

# Set the path of the script and the data
setwd("C:/Users/jalde/Desktop/Bill")

# Load and format the raw data
df <- read.csv("data.csv", sep=";", dec=",") # Spanish Excel save csv data with ";" as separator and "," for decimals
colnames(df) <- c("Date", "HIPC.Index")
df$Date <- as.Date(df$Date, "%d/%m/%Y")

# Modify the data according to your needs
# I will take the beginning of my data series from the founding date of the European Central Bank (June 1, 1998).
# Then, I calculate the loss of purchasing power from the beginning. 
df <- df[df$Date >= as.Date("1998-05-31"),]
df$PPP <- df$HIPC.Index[1]/df$HIPC.Index


#Load the banknote image
bill <- readJPEG("Euro Banknote.jpg")
bill <- rasterGrob(bill, width=unit(1,"npc"), height=unit(1,"npc"), interpolate=TRUE) 

# Draw the chart
graph <- ggplot(df, aes(x = Date, y = PPP)) +
  
  # First draw the banknote. You must set the starting position of axis Y "ymin"
  annotation_custom(bill, xmin = -Inf, xmax = Inf, ymin = 0, ymax = Inf) +
  
  # Then draw over it the white ribbon from the top of the graph to the data series
  geom_ribbon(aes(ymin = PPP, ymax = Inf), fill = "white") +
  geom_line(size=1, colour="#000000") +
  
  # Add the appropriate scale
  scale_x_date(date_breaks="1 year",date_labels = "%Y", expand=c(0,0)) +
  scale_y_continuous(expand=c(0,0), labels=scales::percent, limits = c(0,1), breaks=seq(0, 1, 0.1)) +
  
  # Put the labels you want to the chart
  labs(
    title = "Purchasing Power of Euro",
    subtitle = "Founding date of the ECB (June 1, 1998) = 100%",
    x="",
    y="",
    caption="Data: HICP - Overall Index of Euro Area. Source: ECB Statistical Data Warehouse.") +
  
  # Add a theme
  theme_minimal()

# Plot it!
graph