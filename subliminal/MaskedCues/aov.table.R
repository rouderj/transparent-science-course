aov.table <- function(input, dtfrm) {
  contrasts(dtfrm$Condition) <- c(-1, 1, 0, 0)
  
  as.data.frame(summary.aov(object = aov(dv ~ Condition, 
                                         data = dtfrm[!(is.na(dtfrm$dv)|is.infinite(dtfrm$dv)),]),
                            split  = list(Condition=list("Accuracy vs. Speed"=1)))[[1]])
}