# Input ADaM data in a teal application

library(teal)
library(scda)

# using cdisc_dataset, keys are automatically derived for standard datanames
# (although they can be overwritten)
adsl <- synthetic_cdisc_data("latest")$adsl
dataset_adsl <- cdisc_dataset("ADSL", adsl)
class(dataset_adsl)

adsl <- synthetic_cdisc_data("latest")$adsl
adtte <- synthetic_cdisc_data("latest")$adtte

cdisc_data_obj <- cdisc_data(
  cdisc_dataset(dataname = "ADSL", x = adsl, code = "ADSL <- synthetic_cdisc_data(\"latest\")$adsl"),
  cdisc_dataset(dataname = "ADTTE", x = adtte, code = "ADTTE <- synthetic_cdisc_data(\"latest\")$adtte")
)
class(cdisc_data_obj)

# which is equivalent to:
example_data <- cdisc_data(
  cdisc_dataset(
    dataname = "ADSL",
    x = adsl,
    code = "ADSL <- synthetic_cdisc_data(\"latest\")$adsl",
    keys = c("STUDYID", "USUBJID")
  ),
  cdisc_dataset(
    dataname = "ADTTE",
    x = adtte,
    code = "ADTTE <- synthetic_cdisc_data(\"latest\")$adtte",
    parent = "ADSL",
    keys = c("USUBJID", "STUDYID", "PARAMCD")
  ),
  join_keys = join_keys(
    join_key("ADSL", "ADSL", c("STUDYID", "USUBJID")),
    join_key("ADTTE", "ADTTE", c("USUBJID", "STUDYID", "PARAMCD")),
    join_key("ADSL", "ADTTE", c("STUDYID", "USUBJID"))
  )
)

app <- init(
  data = example_data,
  modules = example_module()
)

if (interactive()) {
  shinyApp(app$ui, app$server)
}