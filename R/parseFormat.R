# prob{c}/x{c}_y{l}_z{n}/repl{i}/ps.csv
parseFormat = function(s, param.sep = param.sep, file.ext = ".csv") {
  checkmate::assertString(s, null.ok = FALSE)

  # remove files extension
  s = gsub(paste0(file.ext, "$"), "", s)

  exploded = strsplit(s, split = "/", fixed = TRUE)[[1L]]
  # how many levels are there?
  n.exploded = length(exploded)

  #print(exploded)

  exploded = lapply(exploded, function(fragment) {
    exploded2 = strsplit(fragment, split = param.sep, fixed = TRUE)[[1L]]
    return(exploded2)
  })

  # flatten structure
  exploded = purrr::flatten(exploded)
  #print(exploded)


  # now save positions which are to be imported (those with {.} at the end)
  param.positions = which(sapply(exploded, base::endsWith, "}"))
  #print(param.positions)

  # now extract param types, i.e., everything inbetween curcle braces
  param.types = sapply(exploded[param.positions], function(fragment) {
    gsub("[\\{\\}]", "", regmatches(fragment, gregexpr("\\{.*?\\}", fragment))[[1]])
  })

  #print(param.types)

  param.names = sapply(exploded[param.positions], function(fragment) {
    gsub("\\{.*\\}", "", fragment)
  })
  #print(param.names)

  return(list(
    param.positions = param.positions,
    param.names = param.names,
    param.types = param.types
  ))
}
