# Input general data in a teal application

library(teal)

app <- init(
  data = teal_data(
    dataset("IRIS", iris, code = "IRIS <- iris"),
    dataset("CARS", mtcars, code = "CARS <- mtcars")
  ),
  modules = example_module()
)

if (interactive()) {
  shinyApp(app$ui, app$server)
}
