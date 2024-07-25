#' Query Dataset records
#'
#' @description Query dataset records to select and filter a dataset on ODS
#'
#' @inheritParams get_metadata
#' @inheritDotParams create_query
#'
#' @return A dataframe of records based on the query
#' @export
#'
#' @examples
#' \dontrun{
#'
#' query_dataset(dataset_id = "sk-stat-112",search_in="bezirk_bezeichnung",search_for="Frauenfeld",order_by="plz",asc=FALSE,select=c("bezirk_bezeichnung","plz","ortschaft"))
#' }
query_dataset_records <- function(domain = NULL,dataset_id,...){

  domain <- check_domain(domain)


  full_query <- create_query(...)
  url_part <- paste0("https://",domain,"/api/explore/",current_version,"/catalog/datasets/",dataset_id,"/records?",full_query)

  url <- paste0(url_part,"&limit=100")

  res <- httr::GET(url)

  temp_result <- httr::content(res,as = "text")
  temp_result <- jsonlite::fromJSON(temp_result)

  count <- temp_result$total_count
  data <- temp_result$results

  limit <- 100
  offset <- 0
  total <- 100


  if (res$status_code!=200){
    stop(paste0("Error: ",temp_result$error_code,": ",temp_result$message))
  }
  if (count==0){
    stop("No Data available.")
  }


  if (count>total){
    result_list <- list(data)
    names(result_list) <- paste0(offset)

    while(count>total){
      offset <- offset + limit
      total <- offset +limit

      full_query <- URLencode(paste0(full_query,"&offset=",offset))

      url <- paste0(url_part,"&limit=",limit,"&offset=",offset)

      res <- httr::GET(url)
      temp_result <- httr::content(res,as = "text")
      result_list[[paste0(offset)]] <- jsonlite::fromJSON(temp_result)$results
    }

    data <- do.call(rbind,result_list)
    rownames(data) <- NULL
  }

  return(data)

}


