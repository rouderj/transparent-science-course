library(shiny)
library(DBI)

source('mc.helpers.R')

ui <- fluidPage(
  h3("Iteratively load the Masked Cues data"),
  sidebarLayout(
    
    sidebarPanel(
      h5("Load more rows:"),
      numericInput("nrows", label = NULL, 32),
      actionButton("go", "Go"),
      h5("Dependent variable:"),
      radioButtons("dv", label = NULL, 
                   choices = c("Accuracy", "Reaction time", "Distance", "Speed")),
      hr(),
      tableOutput("loc"),
      hr(),
      downloadButton('downloadCode', 'Download R code')
    ),
    
    mainPanel(
      textOutput("sql"),
      textOutput("nrw"),
      hr(),
      tableOutput("tbl"),
      plotOutput("plt")
    )
  )
)

server <- function(input, output, session) {
  add.data <- eventReactive(input$go, {
    new.data <- RMySQL::fetch(res, n = input$nrows)
    
    text.cols <- c("Location", "Condition")
    new.data[text.cols] <- lapply(new.data[text.cols], as.factor)
    new.data$ReactionTime[new.data$ReactionTime < 0.1] <- NA
    new.data$dv = new.data$Accuracy
    
    if (is.null(dtfrm)) {  tmp <<- new.data             }
    else                {  tmp <<- rbind(dtfrm, new.data)  }
    
    tmp$dv <- switch(input$dv,
                       "Accuracy"      = 1/tmp$Accuracy,
                       "Distance"      = tmp$Accuracy,
                       "Reaction time" = tmp$ReactionTime,
                       "Speed"         = 1/tmp$ReactionTime)
    tmp$dv[is.infinite(tmp$dv)] = NA
    
    dtfrm <<- tmp
  })
  
  output$tbl <- renderTable({  aov.table(input, dtfrm = add.data())       })
  output$plt <- renderPlot ({  aov.plot (input, dtfrm = add.data())       })
  output$nrw <- renderText ({  rec.text (input, dtfrm = add.data())       })
  output$sql <- renderText ({  sql.text (input, dtfrm = add.data(), res)  })
  output$loc <- renderTable({  loc.table(input, dtfrm = add.data())       })
  
  output$downloadCode <- downloadHandler(
    filename = function() { 
      "MaskedCues.zip" 
      },
    content = function(file) { 
      file.copy(from      = 'MaskedCues.zip', 
                to        = file, 
                copy.date = TRUE)
      }
  )
}

onStart <- function() {
  ## Open database connection
  gbt <<- RMySQL::dbConnect(
    drv      =  RMySQL::MySQL(),
    user     = 'guest',
    host     = '128.200.38.126',
    port     =  3306,
    dbname   = 'CIDLAB')
  
  ## Prepare query
  res <<- RMySQL::dbSendQuery(conn      =  gbt, 
                              statement = "SELECT MaskedCues.Accuracy, MaskedCues.ReactionTime, MaskedCues.Condition, MaskedCues.Location FROM MaskedCues where Phase = 'Experiment'")
  
  ## Prepare data frame
  dtfrm <<- NULL
  
  ## Prepare cleanup
  onStop(function() {
    RMySQL::dbDisconnect(gbt)
  })
}

shinyApp(ui, server, onStart)


