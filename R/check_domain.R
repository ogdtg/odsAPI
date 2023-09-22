#' Check the domain
#'
#' @param domain
#'
#' @return a ceaned domain without https/http/ prefix
#' @export
#'
#' @examples
#'
#' \notrun{
#' check_domain("data.tg.ch")
#' }
#'
#'
check_domain <- function(domain){
  if (is.null(domain)){
    domain <- get_domain()
    if (is.null(domain)){
      stop("No domain is set. Please use set_domain() or pass the domain as an argument to the function.")
    }
    if (domain==""){
      stop("No domain is set. Please use set_domain() or pass the domain as an argument to the function.")
    }
  } else {
    domain <- is_ods_domain(domain)
  }
  return(domain)
}
