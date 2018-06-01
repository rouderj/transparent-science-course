library(shiny)
library(DBI)

## Open database connection
gbt <- RMySQL::dbConnect(
    drv      =  RMySQL::MySQL(),
    user     = 'guest',
    host     = '128.200.38.126',
    port     =  3306,
    dbname   = 'CIDLAB')
  
## Prepare query
mc.data <- RMySQL::dbReadTable(gbt, "MaskedCues")  
