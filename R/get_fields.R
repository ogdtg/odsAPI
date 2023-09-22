#' Get Dataset Fields
#'
#' @inheritDotParams  get_metadata
#'
#' @return A list of fields from the metadata of the given dataset_id
#' @export
#'
#' @examples
#' \dontrun{
#' get_fields("sk-stat-111")
#' }
get_fields <- function(...){
  metadata <- get_metadata(...)

  return(metadata["fields"][[1]])
}
