#' Download the data catalog
#'
#' @description Download the catalog with all available metadata of all publicly available datasets from the given domain
#' @param domain domain of the portal (z.B. data.tg.ch). If non domain is passed to the function, the currently set domain or the domain from th Environment will be used.
#'
#' @return a nested data.frame with metadata of all datasets publicly available on the platform
#' @export
#'
#' @examples
#' \notrun{
#' get_catalog("data.tg.ch")
#'
#' # If domain is already set
#' get_catalog()
#' }
#'
get_catalog <- function(domain = NULL){

  domain <- check_domain(domain)

  res = httr::GET(paste0("https://",domain,"/api/explore/",current_version,"/catalog/exports/json"))

  if (res$status_code!=200){
    stop(paste0("The API returned an error (HTTP ERROR ",res$status_code,") . Please visit ",domain," for more information"))
  }

  result=jsonlite::fromJSON(rawToChar(res$content), flatten = TRUE)
  return(result)

}
