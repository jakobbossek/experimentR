parseFilePath = function(filepath, format, param.sep = "_", file.ext = ".csv") {
  #checkmate::assertFile(filepath, access = "r")
  checkmate::assertList(format, len = 3L)

  # now we need to parse the file in the way we did with the format string

  # first remove the file extension
  filepath = gsub(paste0(file.ext, "$"), "", filepath)

  # now go and explode string by system file separator
  #FIXME: can I explode by / and "_" at the same time?
  exploded = strsplit(filepath, split = "/", fixed = TRUE)[[1L]]

  #print(exploded)

  exploded = lapply(exploded, function(fragment) {
    exploded2 = strsplit(fragment, split = param.sep, fixed = TRUE)[[1L]]
    return(exploded2)
  })

  #FIXME: this would not be necessary if I could explode by / and _ simultaneously
  exploded = purrr::flatten(exploded)

  #print(exploded)

  # WOW! Nice!
  # Now extract relevant positions from exploded string
  meta = exploded[format$param.positions]
  n.meta = length(meta)

  #print(meta)

  #FIXME: I do not need this
  type.funs = paramTypesToTypeConvertFunctions(format$param.types)
  #print(type.funs)

  # finally convert parameters
  meta = lapply(seq_len(n.meta), function(i) {
    type.fun = type.funs[[i]]
    do.call(type.fun, list(meta[i]))
  })
  names(meta) = format$param.names

  #print(meta)

  return(meta)
}
