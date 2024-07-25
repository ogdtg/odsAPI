#' Query dataset
#'
#' @description Query a dataset and use \href{https://help.opendatasoft.com/apis/ods-explore-v2/#section/Opendatasoft-Query-Language-(ODSQL)}{ODSQL Syntax} to refine your query. With this function, it is possible to download only the needed part of the dataset.
#'
#' @param dataset_id ID of the dataset to query.
#' @param ... Where clause parameters. See \href{https://help.opendatasoft.com/apis/ods-explore-v2/#section/Opendatasoft-Query-Language-(ODSQL)/Where-clause}{ODSQL where clause}. You can also use `from` and `to` to select a timespan. The function will automatically use the first variable of type date and apply the timespan on that variable.
#' @param group_by_fields Vector of fields to group by. See \href{https://help.opendatasoft.com/apis/ods-explore-v2/#section/Opendatasoft-Query-Language-(ODSQL)/Group-by-clause}{ODSQL Group by clause}.
#' @param order_by_fields Vector of fields to order by. See \href{https://help.opendatasoft.com/apis/ods-explore-v2/#section/Opendatasoft-Query-Language-(ODSQL)/Order-by-clause}{ODSQL Order by clause}.
#' @param select_fields Vector of fields to be selected. See \href{https://help.opendatasoft.com/apis/ods-explore-v2/#section/Opendatasoft-Query-Language-(ODSQL)/Select-clause}{ODSQL select clause}.
#' @param .domain Domain of the ODS API.
#' @param predicates See \href{https://help.opendatasoft.com/apis/ods-explore-v2/#section/ODSQL-predicates}{ODSQL predicates}.
#' @param key API key for authentication.
#'
#' @return A dataset.
#' @export
#'
#' @examples
#' \dontrun{
#' dataset <- query_dataset(
#'   dataset_id = "example_dataset",
#'   group_by_fields = c("field1", "field2"),
#'   order_by_fields = c("field3"),
#'   select_fields = c("field1", "field2"),
#'   .domain = "your_domain.opendatasoft.com",
#'   key = "your_api_key",
#'   from = "2020-01-01",
#'   to = "2021-01-01"
#' )
#' print(dataset)
#' }
query_dataset <- function(.domain=NULL, dataset_id, group_by_fields=NULL, order_by_fields=NULL, select_fields=NULL, predicates=NULL, key=Sys.getenv("ODS_KEY"), ...) {

  domain <- odsAPI::check_domain(.domain)

  fields <- odsAPI::get_fields(dataset_id = dataset_id)
  date_field <- fields$name[which(fields$type == "date")][1]

  base_url <- paste0("https://", domain, "/api/explore/",odsAPI::current_version,"/catalog/datasets/", dataset_id, "/exports/csv?where=")
  query_list <- list(...)

  where_clause <- sapply(seq_along(query_list), function(i) {


    # Var Name
    var <- names(query_list)[i]

    # Value
    val <- query_list[[i]]

    field_type <- fields$type[fields$name==var]


    if (length(val)>1){
      operator <- " IN "
      if (field_type=="text"){
        val <- paste0('"',val,'"')
      }
      val <- paste0("(",paste0(val,collapse = ","),")")

    } else {
      operator <- "="
      val <- paste0("'", val, "'")
    }

    if (is.null(val)) {
      NULL
    } else {
      if (var == "from") {
        if (is.na(date_field)) {
          NULL
        } else {
          paste0(date_field, ">=date'", val, "' ")
        }
      } else if (var == "to") {
        if (is.na(date_field)) {
          NULL
        } else {
          paste0(date_field, "<=date'", val, "' ")
        }
      } else {
        paste0(var, operator, val)
      }
    }
  }) %>% unlist() %>% paste0(collapse = "%20and%20")

  predicates_clause <- NULL
  if (!is.null(predicates)) {
    predicates_clause <- predicates %>% paste0(collapse = "%20and%20")
    if (where_clause == "") {
      where_clause <- predicates_clause
    } else {
      where_clause <- paste0(where_clause, "%20and%20", predicates_clause)
    }
  }

  group_by_clause <- NULL
  if (!is.null(group_by_fields)) {
    group_by_clause <- paste0(group_by_fields, collapse = "%2C") %>% paste0("&group_by=", .)
  }

  order_by_clause <- NULL
  if (!is.null(order_by_fields)) {
    order_by_clause <- paste0(order_by_fields, collapse = "%2C") %>% paste0("&order_by=", .)
  }

  select_clause <- NULL
  if (!is.null(select_fields)) {
    select_clause <- paste0(select_fields, collapse = "%2C") %>% paste0("&select=", .)
  }

  if (!is.null(key) && key != "") {
    url <- paste0(base_url, where_clause, group_by_clause, order_by_clause, select_clause, "&limit=-1&apikey=", key) %>% gsub(replacement = "%20", pattern = " ")
  } else {
    url <- paste0(base_url, where_clause, group_by_clause, order_by_clause, select_clause, "&limit=-1") %>% gsub(replacement = "%20", pattern = " ")
  }

  result <- tryCatch({
    read.table(url,stringsAsFactors = F,sep = ";",header = T,check.names = F,colClasses = "character")
  }, error = function(cond){
    response <- httr::GET(url)
    httr::content(response)
  })


  return(result)
}
