#' Get Dataset Metas
#'
#' @inheritDotParams  get_metadata
#'
#' @return A list of metadata (without the fields) from the given dataset_id. Every List element represents on of the different metadata types on Opendatasoft.
#' @export
#'
#' @examples
#' \dontrun{
#' get_metas("sk-stat-111")
#' }
get_metas <- function(...){
  metadata <- get_metadata(...)

  return(metadata["metas"][[1]])
}
