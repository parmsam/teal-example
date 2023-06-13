# Delayed Data Loading (DDL)
library(teal)
# library(teal.data)

person_generator <- function() {
  return(
    data.frame(
      ID = factor(1:8),
      AGE = c(40, 23, 56, 11, 17, 71, 23, 56)
    )
  )
}

pet_generator <- function() {
  return(
    data.frame(
      ID = factor(1:10),
      TYPE = rep(c("CAT", "DOG"), 5),
      COLOR = c("GINGER", rep("BROWN", 5), rep("BLACK", 4)),
      PERSON_ID = factor(c(5, 4, 3, 3, 3, 1, 8, 1, 2, 2))
    )
  )
}


app <- init(
  data = teal_data(
    fun_dataset_connector("PERSON", fun = person_generator, keys = "ID") %>%
      mutate_dataset("PERSON$SEX <- rep(c('M', 'F'), 4)"),
    fun_dataset_connector("PETS", fun = pet_generator, keys = "ID")
  ) %>%
    mutate_join_keys("PERSON", "PETS", c("ID" = "PERSON_ID")),
  modules = example_module()
)

if (interactive()) {
  shinyApp(app$ui, app$server)
}