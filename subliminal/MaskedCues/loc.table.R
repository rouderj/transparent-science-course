loc.table <- function(input, dtfrm) {
  if (!is.null(dtfrm)) {
    d <- as.data.frame(plyr::count(dtfrm, "Location"))
  }
}
