#' Get Dataset
#'
#' Download a dataset as data.frame by its dataset_id
#'
#' @inheritParams get_metadata
#'
#' @return A data.frame containing the requested daaset from Opendatasoft.
#' @export
#'
#' @examples
#' \dontrun{
#' get_dataset(domain = "data.tg.ch","sk-stat-112")
#' }
get_dataset <- function(domain=NULL,dataset_id){


  domain <- check_domain(domain)

  url <- paste0("https://",domain,"/api/explore/",current_version,"/catalog/datasets/",dataset_id,"/exports/json")



  res <- httr::GET(url)

  result_text <- httr::content(res,as="text")
  result_data <- jsonlite::fromJSON(result_text)

  if (res$status_code!=200){
    stop(paste0("HTTP ERROR ",res$status_code,": ",result_data$error_code,": ",result_data$message))
  }
  return(result_data)



}
