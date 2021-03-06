## paths+packages.R
# This script holds packages, paths, color schemes, etc which are shared among scripts.

## packages
require(lubridate)
require(grid)
require(gridExtra)
require(hydrostats)
require(waterData)
require(rgdal)
require(raster)
require(rgeos)
require(maptools)
require(broom)
require(viridis)
require(gtable)
require(zoo)
require(gstat)
require(geosphere)
require(magrittr)
require(quantreg)
require(ggplot2)
require(dplyr)
require(reshape2)
require(GGally)

## labels
labs.mo <- c("1"="Jan", "2"="Feb", "3"="Mar", "4"="Apr", "5"="May", "6"="Jun",
             "7"="Jul", "8"="Aug", "9"="Sep", "10"="Oct", "11"="Nov", "12"="Dec")

## paths to external datasets (e.g. global geospatial datasets on GSAS server)
# directory with raw .mat files from Hylke
dir.Q.raw <- file.path("Z:/2.active_projects", "Zipper", "1.Spatial_data", "global", "ro_runoff", "1original", "GlobalDailyStreamflow")

# directory to save derived products from global daily streamflow
dir.Q.derived <- file.path("Z:/2.active_projects", "Zipper", "1.Spatial_data", "global", "ro_runoff", "2derived", "GlobalDailyStreamflow")

## ggplot theme
windowsFonts(Arial=windowsFont("TT Arial"))
theme_scz <- function(...){
  theme_bw(base_size=10, base_family="Arial") + 
    theme(
      text=element_text(color="black"),
      axis.title=element_text(face="bold", size=rel(1)),
      axis.text=element_text(size=rel(1)),
      strip.text=element_text(size=rel(1)),
      legend.title=element_text(face="bold", size=rel(1)),
      legend.text=element_text(size=rel(1)),
      panel.grid=element_blank())
}

theme_set(theme_scz())

## color palettes
# categorical color palette from https://sashat.me/2017/01/11/list-of-20-simple-distinct-colors/
col.cat.grn <- "#3cb44b"   # green
col.cat.yel <- "#ffe119"   # yellow
col.cat.org <- "#f58231"   # orange
col.cat.red <- "#e6194b"   # red
col.cat.blu <- "#0082c8"   # blue
col.gray <- "gray65"       # gray, for annotation lines on plots etc

## functions
# extract p-value from linear model fits
lmp <- function (modelobject) {
  if (class(modelobject) != "lm") stop("Not an object of class 'lm' ")
  f <- summary(modelobject)$fstatistic
  if (is.null(f)){
    return(NaN)
  } else {
    p <- pf(f[1],f[2],f[3],lower.tail=F)
    attributes(p) <- NULL
    return(p)
  }
}

# extract legend - https://stackoverflow.com/questions/13649473/add-a-common-legend-for-combined-ggplots
g_legend<-function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)}

# find month range - deals with end of year issues
min.month.range <- function(x) {
  # modified from Maurits Evers - https://stackoverflow.com/questions/51508374/find-temporal-range-of-months-rolling-over-year
  x1 <- x
  x2 <- ifelse(x <= 6, x + 12, x)
  min(diff(range(x1)), diff(range(x2)))
}
min.DOY.range <- function(x) {
  # modified from Maurits Evers - https://stackoverflow.com/questions/51508374/find-temporal-range-of-months-rolling-over-year
  x1 <- x
  x2 <- ifelse(x <= 182.5, x + 182.5, x)
  min(diff(range(x1)), diff(range(x2)))
}
