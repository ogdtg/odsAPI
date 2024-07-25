#' Checks if the given domain is an ODS domain
#'
#' @description Performs an API Call and checks whether the resulting status code is 200
#'
#' @param domain a domain (for example data.tg.ch)
#'
#' @return cleaned domain if the domain is an ODS Domain (status code == 200) and NULL otherwise.
#'
#' @examples
#' \dontrun{
#' is_ods_domain("data.tg.ch")
#' #TRUE
#' }

is_ods_domain <- function(domain){
  domain <- gsub("https://","",domain)
  domain <- gsub("http://","",domain)
  domain <- gsub("http:/","",domain)


  res <- tryCatch({
    httr::GET(paste0("https://",domain,"/api/explore/",odsAPI::current_version,"/"))
    },error = function(cond){
      stop(paste0("domain ",domain," is not an ODS domain."))
    })

  if (res$status_code==200){
    return(domain)
  } else {
    stop(paste0("domain ",domain," is not an ODS domain."))
  }

}
