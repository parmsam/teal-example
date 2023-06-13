# load packages
library(teal)
library(teal.modules.general)
# library(teal.code)
library(tidytuesdayR)
library(dplyr)
library(scda)

# load modules and functions
sapply(list.files('R', full.names = T), source)

# declare dataset
tuesdata <- tidytuesdayR::tt_load('2023-05-23')
squirrel_data <- tuesdata$squirrel_data

# explore a subset of the data
exampledata <- squirrel_data %>%
  mutate(across(where(is.character), as.factor)) %>%
  slice_sample(n = 100)

# setup app
app <- init(
  data = teal_data(
    dataset("exampledata", exampledata)
  ),
  modules = 
    modules(
      tm_front_page(
        label = "Dataset info",
        header_text =
          c("Info about data source" =
              "Squirrel data from the {tidytuesdayR} package"
            ),
        tables = list(
          `Datasets` =
            data.frame(
              Packages =
                c("teal.modules.general")
              )
          )
      ),
      tm_data_table("Data table"),
      tm_variable_browser("Variable browser"),
      tm_missing_data("Missing data"),
      tm_g_distribution(
        "Distribution",
        dist_var = extracted_numeric,
        strata_var = data_extract_spec(
          dataname = "exampledata",
          filter = distr_filter_spec
        ),
        group_var = data_extract_spec(
          dataname = "exampledata",
          filter = distr_filter_spec
        )
      ),
      tm_t_crosstable(
        "Table choices",
        x = extracted_fct,
        y = extracted_fct
      ),
      tm_g_association(
        ref = extracted_num,
        vars = extracted_fct3
      ),
      tm_g_scatterplot(
        "Scatterplot",
        x = extracted_num,
        y = extracted_num2,
        row_facet = extracted_factors,
        col_facet = extracted_factors,
        color_by = extracted_factors,
        size = 3, alpha = 1,
        plot_height = c(600L, 200L, 2000L)
      ),
      tm_file_viewer("Code viewer")
  ),
  title = "Data explorer using {teal}"
)

# run app
if (interactive()) {
  shinyApp(app$ui, app$server)
}

