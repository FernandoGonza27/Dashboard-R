library(shiny)
library(DT)
library(ggplot2)

ui <- fluidPage(
  titlePanel(
    div("Laboratorio 3", style = "color: white; background-color: blue; padding: 10px; text-align: center;")
  ),
  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Filtrar por País:", choices = NULL)
    ),
    mainPanel(
      h3("Montos totales:"),
      fluidRow(
        column(3, wellPanel(
          h4("Total Unit Price"),
          textOutput("total_unit_price")
        )),
        column(3, wellPanel(
          h4("Total Quantity"),
          textOutput("total_quantity")
        )),
        column(3, wellPanel(
          h4("Total Discount"),
          textOutput("total_discount")
        )),
        column(3, wellPanel(
          h4("Total Extended Price"),
          textOutput("total_extended_price")
        ))
      ),
      plotOutput("avg_unit_price_chart"),
      DTOutput("invoices_table")
    )
  )
)
