library(teal)
library(teal.reporter)

example_reporter_module <- function(label = "Example") {
  module(
    label,
    server = function(id, data, reporter, filter_panel_api) {
      with_filter <- !missing(filter_panel_api) && inherits(filter_panel_api, "FilterPanelApi")
      checkmate::assert_class(data, "tdata")
      moduleServer(id, function(input, output, session) {
        dat <- reactive(data[[input$dataname]]())
        output$nrow_ui <- renderUI({
          sliderInput(session$ns("nrow"), "Number of rows:", 1, nrow(data[[input$dataname]]()), 10)
        })
        
        table_q <- reactive({
          req(input$nrow)
          
          teal.code::new_qenv(tdata2env(data), code = get_code(data)) %>%
            teal.code::eval_code(
              substitute(
                result <- head(data, nrows),
                list(
                  data = as.name(input$dataname),
                  nrows = input$nrow
                )
              )
            )
        })
        
        output$table <- renderTable(table_q()[["result"]])
        
        ### REPORTER
        card_fun <- function(card = ReportCard$new(), comment) {
          card$set_name("Table Module")
          card$append_text(paste("Selected dataset", input$dataname), "header2")
          card$append_text("Selected Filters", "header3")
          if (with_filter) {
            card$append_text(filter_panel_api$get_filter_state(), "verbatim")
          }
          card$append_text("Encoding", "header3")
          card$append_text(
            yaml::as.yaml(
              stats::setNames(lapply(c("dataname", "nrow"), function(x) input[[x]]), c("dataname", "nrow"))
            ),
            "verbatim"
          )
          card$append_text("Module Table", "header3")
          card$append_table(table_q()[["result"]])
          card$append_text("Show R Code", "header3")
          card$append_text(paste(teal.code::get_code(table_q()), collapse = "\n"), "verbatim")
          if (!comment == "") {
            card$append_text("Comment", "header3")
            card$append_text(comment)
          }
          card
        }
        teal.reporter::add_card_button_srv("addReportCard", reporter = reporter, card_fun = card_fun)
        teal.reporter::download_report_button_srv("downloadButton", reporter = reporter)
        teal.reporter::reset_report_button_srv("resetButton", reporter)
        ###
      })
    },
    ui = function(id, data) {
      ns <- NS(id)
      teal.widgets::standard_layout(
        output = tableOutput(ns("table")),
        encoding = tagList(
          div(
            teal.reporter::add_card_button_ui(ns("addReportCard")),
            teal.reporter::download_report_button_ui(ns("downloadButton")),
            teal.reporter::reset_report_button_ui(ns("resetButton"))
          ),
          selectInput(ns("dataname"), "Choose a dataset", choices = names(data)),
          uiOutput(ns("nrow_ui"))
        )
      )
    },
    filters = "all"
  )
}

app <- init(
  data = teal_data(
    dataset("AIR", airquality, code = "data(airquality); AIR <- airquality"),
    dataset("IRIS", iris, code = "data(iris); IRIS <- iris"),
    check = FALSE
  ),
  modules = list(
    example_reporter_module(label = "with Reporter"),
    example_module(label = "without Reporter")
  ),
  filter = list(AIR = list(Month = c(5, 5))),
  header = "Example teal app with reporter"
)

if (interactive()) shinyApp(app$ui, app$server)