#' Query Data Catalog
#'
#' @description Query data catalog to select and filter a catalog on ODS
#'
#' @inheritParams set_domain
#' @inheritDotParams create_query
#'
#' @return A data.frame with the content from the defined query
#' @export
#'
#' @examples
#' \dontrun{
#'
#' query_catalog(domain = "data.tg.ch", search_for="siedlung", search_in="title")
#'
#' }
#'
query_catalog <- function(domain = NULL,...){

  domain <- check_domain(domain)


  full_query <- create_query(...)
  url_part <- paste0("https://",
                     domain,
                     "/api/explore/",
                     current_version,
                     "/catalog/datasets?",
                     query)

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
    stop(paste0("Error: ",result$error_code,": ",result$message))
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

      query <- URLencode(paste0(query,"&offset=",offset))

      url <- paste0("https://",
                    domain,
                    "/api/explore/",
                    current_version,
                    "/catalog/datasets?",
                    query)

      res <- httr::GET(url)
      temp_result <- httr::content(res,as = "text")
      result_list[[paste0(offset)]] <- jsonlite::fromJSON(temp_result)$results
    }

    data <- do.call(rbind,result_list)
    rownames(data) <- NULL
  }

  return(data)

}

