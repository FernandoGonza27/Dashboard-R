# ui.R

# Cargar librerías necesarias
library(shiny)
library(DT)

# Definir la interfaz de usuario
ui <- fluidPage(
  # Título de la pestaña del navegador y estilos personalizados
  tags$head(
    tags$title("Laboratorio 3 Dashboard - R Shiny"),  # Título en la pestaña del navegador
    tags$style(HTML("
      /* Estilos personalizados para el div del desarrollador */
      #developer-info {
        background-color: #333333;
        color: white;
        padding: 10px;
        text-align: center;
        font-size: 14px;
        position: fixed;
        bottom: 0;
        width: 100%;
      }
    "))
  ),
  
  # Encabezado de la página principal
  titlePanel(
    div("Laboratorio 3 Dashboard R Studio", 
        style = "color: white; background-color: black; padding: 8px; text-align: center;")
  ),
  
  # Layout de la página con panel lateral y panel principal
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
  ),
  
  # Tabla de datos del desarrollador
  # Div con los datos del desarrollador en el pie de página
  uiOutput("developer_info")
  
)
