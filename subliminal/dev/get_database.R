library(shiny)
library(DBI)

# ## Open database connection
# gbt <- RMySQL::dbConnect(
#     drv      =  RMySQL::MySQL(),
#     user     = 'guest',
#     host     = '128.200.38.126',
#     port     =  3306,
#     dbname   = 'CIDLAB')
#   
# ## Prepare query
# mc.data <- RMySQL::dbReadTable(gbt, "MaskedCues")  

# load("mc.Rdata")

# url paper https://osf.io/g84py/

mc.data <- read.csv(url("https://osf.io/wa34r/download"))

frames2ms <- function(d = mc.data, framecol) {
  d[,ncol(d)+1] <- d[,which(colnames(d)==framecol)] / d$RefreshRate
  colnames(d)[ncol(d)] <- sprintf("MilliSec%s", substr(framecol, 7, 32))
  d
}

for (fn in colnames(mc.data)[grepl("Frames", colnames(mc.data))]) {
  mc.data <- frames2ms(mc.data, fn)
}

