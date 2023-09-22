# odsAPI
This R packgage serves as an API wrapper and makes it possible to access the Explore API of all Opendatasoft customers.

## Installation

The package can be installed directly from GitHub

```r

devtools::install_github("ogdtg/odsAPI")
library(odsAPI)

```

## Usage

### Set the Domain

The package allows you to access the Explore API of *every* data dataportal hosted by Opendatasoft. To select, which portal you want to access you need to set the domain correctly.
In this package the domain is the host of the dataportal. The Functions in the package will use this domain to create the URL endpoints later on.

For example if you use the domain *"data.tg.ch"* the functions will create Endpoints that look like this: *https://data.tg.ch/api/explore/v2.1/*.

You can set and use domains in three different ways:


1. Write it to the `.Renviron` File

If you have one domain you want to access most of the time it is best to write a system variable to the `.Renviron` file. In this case your domain will be set over sessions and you won't have to worry about it ever again.

But be careful. In the `.Renviron` file you have to name the system variable correctly.

Use `usethis::edit_r_environ()` to open the `.Renviron` file.

Then add the following variable to the `.Renviron`:
```r
ODS_API_DOMAIN=YOUR_DOMAIN
```

Make sure to **NOT** use quotes around the domain you are setting!


Afterwards save and close the `.Renviron` file. After yopu restart R your changes will take effect.

Then you will be able to access your domain via `Sys.getenv("ODS_API_DOMAIN")`. The package will take care of this automatically. You then just need to use the functions like this:

```r

catalog <- get_catalog()

data <- get_dataset(dataset_id = "sk-stat-111")

```

2. Use `set_domain()`

If you do not want to set your domain permanently for all future sessions, you can use `set_domain()`. This will set the domain for the current session. Of course, you can always overwrite this setting by using another `set_domain()` command. Please note that your `ODS_API_DOMAIN` variable from the `.Renviron` file will be ignored if you use `set_domain()` as long as the current session runs.

```r

set_domain("data.tg.ch")

catalog <- get_catalog()

data <- get_dataset(dataset_id = "sk-stat-111")


```

3. Direct use in the function

Every function has also a `domain` parameter, where you can set the domain directly. Domains set with set_domain or via the `.Renviron` file are ignored in this case.

```r

catalog <- get_catalog(domain = "data.tg.ch")

data <- get_dataset(domain = "data.tg.ch",dataset_id = "sk-stat-111")

```
