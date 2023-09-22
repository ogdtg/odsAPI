# odsAPI
The odsAPI R package serves as an API wrapper, allowing you to seamlessly access the Explore API (version 2.1) of all Opendatasoft customers.

## Installation

To install the package directly from GitHub, you can use the devtools package:
```r

devtools::install_github("ogdtg/odsAPI")
library(odsAPI)

```

## Usage

### Setting the Domain

This package enables access to the Explore API of any data portal hosted by Opendatasoft. To select the specific portal you want to access, you need to set the domain correctly. In this context, the domain refers to the host of the data portal. Functions in the package will utilize this domain to create the necessary API endpoints.

For instance, if you set the domain to **"data.tg.ch,"** the functions will generate endpoints like this: **"https://data.tg.ch/api/explore/v2.1/."**

You can set and use domains in three different ways:


#### Write it to the `.Renviron` File

If you primarily access a single domain, it's advisable to write a system variable to the `.Renviron` file. This ensures that your domain is set across sessions, eliminating the need to configure it repeatedly.

To do this, use `usethis::edit_r_environ()` to open the `.Renviron` file and add the following line:
```r
ODS_API_DOMAIN=YOUR_DOMAIN
```

Ensure that you do not enclose the domain in quotes. After saving and closing the `.Renviron` file, your changes will take effect upon restarting R.

Once set, you can access your domain using `Sys.getenv("ODS_API_DOMAIN")`. The package will handle this automatically, allowing you to use functions like this:
```r

catalog <- get_catalog()

data <- get_dataset(dataset_id = "sk-stat-111")

```

#### Using `set_domain()`

If you prefer not to set a domain permanently for all future sessions, you can use `set_domain()`. This function sets the domain for the current session only. You can overwrite this setting at any time with another `set_domain()` command. Note that using `set_domain()` in the current session will override the `ODS_API_DOMAIN` variable from the `.Renviron` file.
```r

set_domain("data.tg.ch")

catalog <- get_catalog()

data <- get_dataset(dataset_id = "sk-stat-111")


```

#### Direct Usage in the Functions

Each function includes a `domain` parameter, allowing you to set the domain directly. Domains set via `set_domain()` or in the `.Renviron` file are ignored when specifying the domain directly in a function.

```r

catalog <- get_catalog(domain = "data.tg.ch")

data <- get_dataset(domain = "data.tg.ch",dataset_id = "sk-stat-111")

```

### Data Catalog

*Assuming a domain is set*

Retrieve the entire catalog with all metadata using `get_catalog()`

```r

catalog <- get_catalog()

```

You can also query the data catalog, selecting specific columns such as `dataset_id` and `title`, using the `query_catalog()` function:

```r

queried_catalog <- query_catalog(select=c("dataset_id","title"))

```
To explore all querying possibilities, including filtering by description, ordering, date ranges, and more, check the `create_query()` function:

```r

create_query(
  search_in = "description",
  search_for = "Frauenfeld",
  order_by = "records",
  asc = FALSE,
  select = c("dataset_id", "title", "records", "publisher", ),
  date_start = "2020-01-01",
  date_end = "2022-12-31",
  date_var = "last_modified",
  filter_query = "publisher='Dienststelle für Statistik'"
)

```

A common task is to search the data catalog for a specific term in the title. Therefore, the `search_catalog` function wraps the `query_catalog`.
If you just want to search for a specific word in the titles of your datasets you can do the following:

```r

search_catalog(search_for = "wahl")


```

### Metadata

Retrieve full metadata using the `get_metadata` function, which returns a list containing all metadata, including dataset fields. Two wrapper functions are available to fetch:

- Dataset metadata: `get_metas`
- Fields metadata: `get_fields`

```r

# Metas and Fields
full_metadata <- get_metadata("sk-stat-111")

# Fields
fields <- get_fields("sk-stat-111")

# Metas
metas <- get_metas("sk-stat-111")
# Metas


```

### Datasets


Download complete datasets using the `get_dataset` function, providing the `dataset_id` obtained from the catalog:

```r

data <- get_dataset("sk-stat-111")

```


Similar to the catalog, you can query the records of each dataset. For instance:

```r
# Workplaces by Sector and Political Municipality Canton Thurgau
# Arbeitsstätten nach Sektoren und Politischen Gemeinden Kanton Thurgau


querried_data <-
  query_dataset(
    dataset_id = "sk-stat-97",
    filter_query = c("sektor=2", "arbeitsstaetten<10"),
    date_start = "2010",
    date_end = "2020",
    date_var = "jahr",
    order_by = "jahr",
    asc = FALSE
  )


```
