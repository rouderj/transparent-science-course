sql.text <- function(input, dtfrm, res) {
  paste("Statement: ", RMySQL::dbGetStatement(res))
}
