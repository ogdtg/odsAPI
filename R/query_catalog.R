#' Query Catalog with ODSQL
#'
#' @description Instead of downlaoding the whole catalog and all variables, it is also possible to use ODSQL and perform specific queries.
#'
#' @inheritParams set_domain
#' @param query a query based on the ODSQL Syntax
#'
#' @return A Dataframe with the content from the defined query
#' @export
#'
#' @examples
#' \dontrun{
#' query_catalog(domain = "data.tg.ch", query = "select=dataset_id,title&where=suggest(dataset_id,'sk')&limit=100")
#'
#' }
query_catalog <- function(domain = NULL,query){



  limit <- 100
  offset <- 0
  total <- 100

  domain <- check_domain(domain)

  # If there is a limit in the query then account for it
  if(!grepl("limit=",query)){
    query <- paste0(query,"&limit=100")
  } else {
    matches <-gregexpr("&limit=(\\d.+)",query)
    extracted <- regmatches(query, matches)[[1]]
    limit = as.numeric(gsub("&limit=","",extracted))
    total = limit
  }

  query <- URLencode(query)

  url <- paste0("https://",
                domain,
                "/api/explore/",
                current_version,
                "/catalog/datasets?",
                query)

  res <- httr::GET(url)

  temp_result <- httr::content(res,as = "text")
  temp_result <- jsonlite::fromJSON(temp_result)
  count <- temp_result$total_count
  data <- temp_result$results


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

