# Banknote Images in R
In this repository I explain how to draw the famous charts of the loss of purchasing power of the dollar or the euro in R language.

![Banknote chart](https://github.com/Jaldekoa/Banknote-Images-in-R/blob/main/Poder Adquisitivo del €uro en España.jpg)

## Code and explanations
First, the required libraries are: jpeg, grid and ggplot2.

```
require("jpeg")
require("grid")
require("ggplot2")
```

Then, load and format the data according to your needs. Here, I will take the beginning of my data series as of January 1, 2000. and I calculate the loss of purchasing power.

```
URL <- "https://sdw-wsrest.ecb.europa.eu/service/data/ICP/M.ES.N.000000.4.INX?format=csvdata"
df <- read.csv(URL)[c("TIME_PERIOD", "OBS_VALUE")]

df$TIME_PERIOD <- seq.Date(as.Date("1996-02-01"), by="month", length.out = nrow(df)) - 1
df$OBS_VALUE <- as.numeric(df$OBS_VALUE)

df <- df[df$TIME_PERIOD >= as.Date("1999-12-31"),]
df$PPP <- df$OBS_VALUE[1]/df$OBS_VALUE
```

To load your banknote image.

```
bill <- readJPEG("### YOUR BANKNOTE PICTURE ###")
bill <- rasterGrob(bill, width=unit(1,"npc"), height=unit(1,"npc"), interpolate=TRUE)  
```

Last, use ggplot2 to draw the chart.

```
# Draw the chart
graph <- ggplot(df, aes(x = TIME_PERIOD, y = PPP)) +
  
  # First draw the banknote. You must set the starting position of axis Y "ymin"
  annotation_custom(bill, xmin = -Inf, xmax = Inf, ymin = 0, ymax = Inf) +
  
  # Then draw over it the white ribbon from the top of the graph to the data series
  geom_ribbon(aes(ymin = PPP, ymax = Inf), fill = "white") +
  geom_line(size=1, colour="#000000") +
  geom_hline(yintercept=tail(df$PPP, 1), linetype="dashed") + 
  
  # Add the appropriate scale
  scale_x_date(date_breaks="1 year",date_labels = "%Y", expand=c(0,0)) +
  scale_y_continuous(expand = c(0,0), labels = scales::percent, limits = c(0,1), breaks = seq(0, 1, 0.1)) +
  
  # Put the labels you want to the chart
  labs(
    title = "Poder Adquisitivo del €uro en España",
    subtitle = "Desde 2000 hasta 2022. 1 de enero de 2000 = 100%",
    x="",
    y="",
    caption="Elaboración propia.Fuente: ECB Statistical Data Warehouse. Creado por @jaldeko.") +
   
  # Add a theme and other aesthetics modifications
  theme_minimal() +
  theme(plot.caption = element_text(face="italic"), 
        plot.title = element_text(face="bold", hjust=0.5, size=rel(1.5)),
        plot.subtitle = element_text(face="italic", hjust=0.5),
        axis.text.x = element_text(colour = "black", hjust=-0.5, face="bold"),
        axis.text.y = element_text(colour = "black", face="bold"),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(colour="black"),
        axis.ticks = element_line(colour="black"),
        legend.key.height = unit(0.75, 'cm'),
        legend.text = element_text(colour = "black", face="italic", size=rel(0.75)))


# Plot it
graph
```

## Source of the data
 - Spain - HICP - Overall index, Monthly Index, Eurostat, Neither seasonally nor working day adjusted, ECB Statistical Data Warehouse. Link: https://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=122.ICP.M.ES.N.000000.4.INX
