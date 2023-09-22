#' Search the Catalog for specific Searchterms
#'
#' @description Search for specific searchterms in one or more columns of the catalog. Return only those columns yoou select in the select_cols argument.
#'
#' @inheritParams set_domain
#' @param searchterm A string you want to search for in the catalog
#' @param search_in Columns in which the function should search for the given searchterm. This can either be one or several columns. The columns must be present in the select_cols param, too. The default column to search in is the dataset title (`title`)
#' @param select_cols The columns the function should return. If none is given, the function will return all columns from the catalog.
#'
#' @return A data.frame containing the matching datasets
#' @export
#'
#' @examples
#' \dontrun{
#'
#' set_domain("data.tg.ch")
#'
#' search_catalog(searchterm = "siedlung",select_cols = c("dataset_id","title"))
#' }
#'
#'
#'
search_catalog <- function(domain = NULL,searchterm,search_in = "title",select_cols=NULL) {



  search_cols <- paste0(search_in,collapse = ",")

  query <- paste0("where=suggest(",search_cols,",'",searchterm,"')&limit=100")

  if (!is.null(select_cols)){
    selects <- paste0(select_cols,collapse = ",")
    select_query <- paste0("select=",selects,"&")
    query <- paste0(select_query,query)
  }

  data <- query_catalog(domain=domain,query=query)
  return(data)
}

