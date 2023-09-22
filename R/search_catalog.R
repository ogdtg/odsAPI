#' Search the Catalog for specific Searchterms
#'
#' @description This is a wrapper for query_catalog: search for specific searchterms in one or more columns of the catalog. Return only those columns you select in the select_cols argument.
#'
#' @inheritParams set_domain
#' @param search_for The substring the function should search for in the columns specified in `search_in`. If `search_in` is NULL then it will be searched in all columns. This parameter cannot be NULL if `search_in` is specified.
#' @param search_in The column(s) the function should search in for the substring specified in `search_for`. The default column to search in is the dataset title (`title`)
#' @param select One or multiple columns that should be selected and be part of the final result. Can be a vector or a single string.
#'
#' @return A data.frame containing the matching datasets
#' @export
#'
#' @examples
#' \dontrun{
#'
#' set_domain("data.tg.ch")
#'
#' search_catalog(search_for = "siedlung",select = c("dataset_id","title"))
#' }
#'
#'
#'
search_catalog <- function(domain = NULL,search_for,search_in = "title",select=NULL) {


  data <- query_catalog(domain = domain,search_in=search_in,search_for=search_for,select=select)
  return(data)
}

