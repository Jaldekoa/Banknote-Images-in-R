# Banknote Images in R
In this repository I explain how to draw the famous charts of the loss of purchasing power of the dollar or the euro in R language.

![Banknote chart](https://github.com/Jaldekoa/Banknote-Images-in-R/blob/main/Plot.jpg)

## Code and explanations
First, the required libraries are: jpeg, grid and ggplot2.

```
require("jpeg")
require("grid")
require("ggplot2")
```

Do not forget to specify the path to the files.

```
setwd("### YOUR FOLDER'S PATH ###")
```

Then, load and format the data according to your needs. Here, I will take the beginning of my data series from the founding date of the European Central Bank (June 1, 1998) and I calculate the loss of purchasing power from the beginning.

```
df <- read.csv("data.csv", sep=";", dec=",") # Spanish Excel save csv data with ";" as separator and "," for decimals
colnames(df) <- c("Date", "HIPC.Index")
df$Date <- as.Date(df$Date, "%d/%m/%Y")

df <- df[df$Date >= as.Date("1998-05-31"),]
df$PPP <- df$HIPC.Index[1] / df$HIPC.Index
```

To load your banknote image.

```
bill <- readJPEG("### YOUR BANKNOTE PICTURE ###")
bill <- rasterGrob(bill, width = unit(1, "npc"), height = unit(1, "npc"), interpolate = TRUE) 
```

Last, use ggplot2 to draw the chart.

```
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
  
  # Add a theme and other aesthetics modifications
  theme_minimal() +
  theme(plot.title = element_text(face="bold", hjust=0.5, size=rel(1.5)),
        plot.subtitle = element_text(face="italic", hjust=0.5))

# Plot it!
graph
```

## Source of the data
 - HICP - Overall Index of Euro Area, ECB Statistical Data Warehouse. Link: https://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=122.ICP.M.U2.N.000000.4.INX
