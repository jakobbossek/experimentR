paramTypesToTypeConvertFunctions = function(param.types) {
  checkmate::assertCharacter(param.types, min.len = 1L)

  map = list(
    i = "as.integer",
    l = "as.logical",
    c = "as.character",
    n = "as.numeric"
  )

  return(map[param.types])
}
