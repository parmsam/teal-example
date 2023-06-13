extracted_num <- data_extract_spec(
  dataname = "exampledata",
  select = select_spec(
    choices = variable_choices(exampledata),
    # selected = "AGE",
    multiple = FALSE,
    fixed = FALSE
  )
)
extracted_num2 <- data_extract_spec(
  dataname = "exampledata",
  select = select_spec(
    choices = variable_choices(exampledata),
    # selected = "BMRKR1",
    multiple = FALSE,
    fixed = FALSE
  )
)
extracted_fct <- data_extract_spec(
  dataname = "exampledata",
  select = select_spec(
    choices = variable_choices(exampledata),
    # selected = "ARMCD",
    multiple = FALSE,
    fixed = FALSE
  )
)
fact_vars <- names(Filter(isTRUE, sapply(exampledata, is.factor)))
extracted_fct2 <- data_extract_spec(
  dataname = "exampledata",
  select = select_spec(
    choices = variable_choices(exampledata, subset = fact_vars),
    # choices = variable_choices(exampledata),
    # selected = "STRATA2",
    multiple = FALSE,
    fixed = FALSE
  )
)
extracted_fct3 <- data_extract_spec(
  dataname = "exampledata",
  select = select_spec(
    choices = variable_choices(exampledata),
    # selected = "ARMCD",
    multiple = TRUE,
    fixed = FALSE
  )
)
numeric_vars <- names(Filter(isTRUE, sapply(exampledata, is.numeric)))
extracted_numeric <- data_extract_spec(
  dataname = "exampledata",
  select = select_spec(
    choices = variable_choices(exampledata, subset = numeric_vars),
    # selected = "BMRKR1",
    multiple = FALSE,
    fixed = FALSE
  )
)
extracted_factors <- data_extract_spec(
  dataname = "exampledata",
  select = select_spec(
    choices = variable_choices(exampledata, subset = fact_vars),
    selected = NULL,
    multiple = FALSE,
    fixed = FALSE
  )
)

distr_filter_spec <- filter_spec(
  vars = choices_selected(
    variable_choices(exampledata, fact_vars),
    selected = NULL
  ),
  multiple = TRUE
)
