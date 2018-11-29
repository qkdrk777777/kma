#' install.packages & library
#'
#' mom_gamma function will calculate mom estimate for the shape parameter "k" and the scale parameter "theta" by using given sample.
#'
#'  @param package is package names.
#'  @return package & library
#'  @examples #' pack(package=c('sp','plyr'))
#'  @export
pack=function (package, character.only = T, quietly = F, lib.loc = NULL,
          warn.conflicts = T)
{
  if (!character.only) {
    package <- as.character(substitute(package))
  }

  for(i in 1:length(package)){
  loaded <- paste0("package:", package[i]) %in% search()
  if (!loaded) {
    if (!quietly) {
      packageStartupMessage(gettextf("Loading required package: %s",
                                     package[i]), domain = NA)
    }
    value <- tryCatch(library(package[i], lib.loc = lib.loc,
                              character.only = T, logical.return = T, warn.conflicts = warn.conflicts,
                              quietly = quietly), error = function(e) e)
    if (inherits(value, "error")) {
      if (!quietly) {
        msg <- conditionMessage(value)
        cat("Failed with error: ", sQuote(msg), "\n",
            file = stderr(), sep = "")
        .Internal(printDeferredWarnins())
      }
      return(invisible(FALSE))
    }
    if (!value) {
      install.packages(package)
      value <- tryCatch(library(package, lib.loc = lib.loc,
                                character.only = T, logical.return = T, warn.conflicts = warn.conflicts,
                                quietly = quietly), error = function(e) e)
      return(invisible(FALSE))
    }
  }
  else value <- TRUE
  invisible(value)
  }
}
