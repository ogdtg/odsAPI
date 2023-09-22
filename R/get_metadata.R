#' Get Metadata of Dataset
#'
#' @inheritParams set_domain
#' @param dataset_id the dataset_id of the given dataset. The dataset_id can be taken from the respective catalog that can be accessed via `get_catalog()`
#'
#' @return A [list()] of metadata of the given dataset_id, including fields of the dataset
#' @export
#'
#' @examples
#' \dontrun{
#' get_metadata("sk-stat-111")
#' }
get_metadata <- function(domain=NULL,dataset_id){

  domain <- check_domain(domain)

  res = httr::GET(paste0("https://",domain,"/api/explore/",current_version,"/catalog/datasets/",dataset_id))

  if (res$status_code!=200){
    stop(paste0("The API returned an error (HTTP ERROR ",res$status_code,") . Please visit ",domain," for more information"))
  }

  result=jsonlite::fromJSON(rawToChar(res$content), flatten = TRUE)
  return(result)

}
