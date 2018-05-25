aov.plot <- function(input, dtfrm) {
  df.accuracy = dtfrm$dv[dtfrm$Condition=="MaskedAccuracy"]
  df.speed = dtfrm$dv[dtfrm$Condition=="MaskedSpeed"]
  
  qma <- quantile(df.accuracy, 
                  probs = seq(.1, .9, 0.2),
                  na.rm = TRUE,
                  type = 7)
  qms <- quantile(df.speed, 
                  probs = seq(.1, .9, 0.2),
                  na.rm = TRUE,
                  type = 7)
  xl = .4
  
  {
    mns = c(
      mean(df.accuracy, na.rm = TRUE), 
      mean(df.speed   , na.rm = TRUE)
    )
    
    plot(x = 1:2, 
         y = mns,
         xlab = "",
         ylab = input$dv,
         xlim = c(0.6, 2.4),
         ylim = c(min(c(qma,qms))/2, max(c(qma,qms))*1.25),
         cex  = 1.5, pch = 19,
         type = "p", 
         xaxt = "n",
         col  = "black")
    axis(1, at=1:2, labels=c("Accuracy instruction", "Speed instruction"))
    
    for (l in c(1,5)) {
      lines(x = c(1-xl/2, 1+xl/2), y = qma[c(l,l)], col = "red", lwd = 1, lty=2)
      lines(x = c(2-xl/2, 2+xl/2), y = qms[c(l,l)], col = "orange", lwd = 1, lty=2)
    }
    for (l in c(2,4)) {
      lines(x = c(1-xl/2, 1+xl/2), y = qma[c(l,l)], col = "red", lwd = 4)
      lines(x = c(2-xl/2, 2+xl/2), y = qms[c(l,l)], col = "orange", lwd = 4)
    }
    lines(x = c(1-xl/2, 1+xl/2), y = qma[c(3,3)], col = "red", lwd = 7)
    lines(x = c(2-xl/2, 2+xl/2), y = qms[c(3,3)], col = "orange", lwd = 7)
  }
}
