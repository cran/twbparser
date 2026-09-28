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


## ----sheet-shelves, eval=ok---------------------------------------------------
shelves <- twb_sheet_shelves(parser)
head(shelves)

## ----sheet-filters, eval=ok---------------------------------------------------
filters <- twb_sheet_filters(parser)
head(filters)

## ----sheet-axes, eval=ok------------------------------------------------------
axes <- twb_sheet_axes(parser)
head(axes)

## ----sheet-sorts, eval=ok-----------------------------------------------------
sorts <- twb_sheet_sorts(parser)
head(sorts)

## ----sheet-spec, eval=ok------------------------------------------------------
spec <- twb_sheet_spec(parser, sheet = "Sheet 1")
spec

## ----rebuild-kit-setup--------------------------------------------------------
kit_ok <- FALSE
kit_path <- system.file("extdata", "rebuild_kit.twb", package = "twbparser")
if (nzchar(kit_path) && file.exists(kit_path)) {
  kit <- TwbParser$new(kit_path)
  kit_ok <- TRUE
}

## ----unused-fields, eval=kit_ok-----------------------------------------------
# Fields defined but never used anywhere: the safe-to-drop list
twb_unused_fields(kit)

## ----calc-build-order, eval=kit_ok--------------------------------------------
# Calculations in creation order — "Adjusted Ratio" comes after "Profit Ratio";
# the Cycle A/B pair is flagged instead of silently misordered
twb_calc_build_order(kit)

## ----parameter-usage, eval=kit_ok---------------------------------------------
# Where each parameter value flows: formulas, shelves, filters, dashboards
twb_parameter_usage(kit)

## ----dashboard-charts, eval=ok------------------------------------------------
charts <- twb_dashboard_charts(parser)
head(charts)

## ----dashboard-sheets, eval=ok------------------------------------------------
db_sheets <- twb_dashboard_sheets(parser)
head(db_sheets)

## ----dashboard-layout, eval=ok------------------------------------------------
layout <- twb_dashboard_layout(parser)
head(layout)

## ----dashboard-actions, eval=ok-----------------------------------------------
actions <- twb_dashboard_actions(parser)
head(actions)

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


## ----batch-export, eval=exists("parser")--------------------------------------
out <- parse_twb(parser$path,
                 output_dir = file.path(tempdir(), "twbparser-vignette"),
                 overwrite = TRUE, quiet = TRUE)
list.files(out)

