#' Creates a Dataset Query String
#'
#' @description Creates a dataset query to query the datasets from ODS. It is possible to search for specific strings, select columns, select a date range and order the results by a variable
#'
#' @param search_in The column(s) the function should search in for the substring specified in `search_for`
#' @param search_for The substring the function should search for in the columns specified in `search_in`. If `search_in` is NULL then it will be searched in all columns. This parameter cannot be NULL if `search_in` is specified.
#' @param order_by Order the results by a column
#' @param asc If TRUE the results will be ordered in ascending order. If FALSE the order will be descending. This parameter is only relevant if `order_by` is specified. Default is FALSE
#' @param select One or multiple columns that should be selected and be part of the final result. Can be a vector or a single string.
#' @param date_start A string in the form of YYYY-MM-DD or YYYY that represents the start of the date range. `date_var` must be specified, otherwise this parameter won't be evaluated. If `date_end` is not specified, all dataset records from this date on will be returned.
#' @param date_end A string in the form of YYYY-MM-DD or YYYY that represents the start of the date range. `date_var` must be specified, otherwise this parameter won't be evaluated. If `date_start` is not specified, all dataset records up to this date will be returned.
#' @param date_var The variable to which `date_end` and `date_end` refer. Prameter will only be evaluated if either `date_end` or `date_start` is specified
#' @param filter_query A query string where binary operators can be used (see \href{https://help.opendatasoft.com/apis/ods-explore-v2/#section/ODSQL-predicates/Text-comparison-operators}{ODS cocumentation on binary operators}). This can either be a string or a vector of multiple strings. For example 'einwohner>=100' or c('einwohner>=100','gemeinde_name="Aadorf"'). Please note that if you use the equal sign for a string, the string has to be enquoted inside the already enqueted query string(e.g. 'gemeinde_name="Aadorf"' and NOT 'gemeinde_name=Aadorf')
#'
#' @return A String containing a valid query which can later be joined with the URL to the API endpoint.
#'
#' @examples
#' \dontrun{
#'
#' create_query(search_in="bezirk",search_for="Frauenfeld",order_by="plz",asc=FALSE,select=c("bezirk","plz","ortschaft","einwohner",),date_start="2020-01-01",date_end="2022-12-31",date_var="jahr")
#' }
#'
#'
create_query <- function(search_in=NULL,search_for=NULL,order_by=NULL,asc=FALSE,select=NULL,date_start=NULL, date_end=NULL, date_var=NULL,filter_query=NULL){

  if (all(is.null(search_in),
          is.null(search_for),
          is.null(order_by),
          is.null(select),
          is.null(date_start),
          is.null(date_end),
          is.null(date_var),
          is.null(filter_query))){
    message("No query paramters specified. Use get_dataset() instead.")
    return(NULL)
  }

  search_query <- NULL
  date_query <- NULL
  select_query <- NULL
  order_by_query <- NULL
  filter_query_part <- NULL
  #Define Queries

  # Search
  if (!is.null(search_for) & is.null(search_in)) {
    message("No column(s) specified for search_in. Will search in all columns")
    search_query = paste0("suggest('",search_for,"')")
  }

  if (!is.null(search_for) & !is.null(search_in)) {
    search_in <- paste0(search_in,collapse = ",")
    search_query = paste0("suggest(",search_in,",'",search_for,"')")
  }

  # Date Range

  if (is.null(date_var) & any(!is.null(date_start),!is.null(date_end))){
    message("No date_var provided. Date range can not be used.")
  } else if (all(is.null(date_var),is.null(date_end),is.null(date_start))){
    date_query=NULL
  } else {
    if (is.null(date_start) & !is.null(date_end)){
      # Up to date_end
      date_query = paste0(date_var,"<=date'",date_end,"'")
    }
    if (!is.null(date_start) & !is.null(date_end)){
      # from date_start
      date_query = paste0(date_var,">=date'",date_start,"'")
    }
    if (!is.null(date_start) & !is.null(date_end)){
      # date_start to date_end
      date_query = paste0(date_var,">=date'",date_start,"' and ",date_var,"<=date'",date_end,"'")
    }

  }

  # Filter query
  if (!is.null(filter_query)){
    filter_query_part = paste0(filter_query,collapse = " AND ")

  }

  where_query_part <- paste0(c(search_query,date_query,filter_query_part),collapse = " AND ")
  where_query <- paste0("where=",where_query_part)

  # Select
  if (!is.null(select)){
    select_cols <- paste0(select,collapse = ",")
    select_query <- paste0("select=",select_cols)
  }


  # Order by
  if (!is.null(order_by)){
    order_by_query = paste0("order_by=",order_by)

    if (asc !=TRUE){
      order_by_query = paste0(order_by_query," DESC")
    } else {
      order_by_query = paste0(order_by_query," ASC")
    }
  }


  full_query <- URLencode(paste0(c(where_query,select_query,order_by_query),collapse="&"))

  return(full_query)

}
