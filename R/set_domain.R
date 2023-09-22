#init env
user <- new.env()



#' Set the domain for the API Calls
#'
#' @param domain domain of the portal (z.B. data.tg.ch)
#'
#' @export
#'
set_domain <- function(domain) {
  if (!is.null(is_ods_domain(domain))) {
    assign("domain", domain, env = user)

  }
}

#' Get the domain currently used for API Calls
#'
#' @return domain the user set by using set_domain() or the domain the user set in the .Renviron file under ODS_API_DOMAIN
#' @export
#'
get_domain<- function() {
  env_var <- Sys.getenv("ODS_API_DOMAIN")
  if(env_var!=""){
    return(env_var)
  }
  domain <- tryCatch({
    get("domain", user)
  },error = function(cond){
    ""
  })
  return(domain)
}
