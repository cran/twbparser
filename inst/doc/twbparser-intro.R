## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(twbparser)
ok <- FALSE
twb_path <- system.file("extdata", "test_for_wenjie.twb", package = "twbparser")
if (nzchar(twb_path) && file.exists(twb_path)) {
parser <- TwbParser$new(twb_path)
ok <- TRUE
} else {
cat("> Demo .twb not found in installed package. Skipping executable examples.\n")
}



## ----parse-twb, eval=exists("parser")-----------------------------------------
parser$summary
parser$overview

## ----datasources, eval=exists("parser")---------------------------------------
datasources <- parser$get_datasources()
parameters <- parser$get_parameters()

print(head(datasources))
print(head(parameters))

## ----calculated_fields, eval=exists("parser")---------------------------------
head(parser$get_fields())
head(parser$get_calculated_fields(pretty = TRUE, wrap = 120))


## ----insights_1, eval=ok------------------------------------------------------
twb_pages(parser)
twb_pages_summary(parser)



## ----insight_2, eval=ok-------------------------------------------------------


pg <- twb_pages(parser)
nm <- if (nrow(pg)) pg$name[[1]] else NA_character_
if (!is.na(nm)) {
  parser$get_page_composition(nm)
}



## ----insights_3, eval=ok------------------------------------------------------
twb_dashboard_filters(parser)


## ----insights_4, eval=ok------------------------------------------------------
twb_charts(parser)
twb_colors(parser)


## ----relationships-joins, eval=exists("parser")-------------------------------
relations <- parser$get_relationships()

head(relations)

## ----twbx, eval=exists("parser") && !is.null(parser$twbx_path)----------------
# parser$get_twbx_manifest()
# parser$get_twbx_extracts()
# parser$get_twbx_images()
# 

## ----validate, eval=exists("parser")------------------------------------------
v <- parser$validate()
if (isTRUE(v$ok)) {
cat("Relationships validated successfully.\n")
} else {
print(v$issues)
}


