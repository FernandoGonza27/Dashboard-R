# server.R
## Instalar librarys 
##install.packages("shiny")
##install.packages("DBI")
##install.packages("odbc")
##install.packages("dplyr")
##istall.packages("DT")
##install.packages("ggplot2")


library(shiny)
library(DBI)
library(odbc)
library(DT)
library(dplyr)
library(ggplot2)

server <- function(input, output, session) {
  # Conexión a SQL Server
  con <- dbConnect(odbc::odbc(),
                   Driver = "SQL Server",
                   Server = "localhost",
                   Database = "YouDataBase",
                   UID = "User",
                   PWD = "Password",
                   Port = 1433)
  
  # Cargar datos de la vista 'invoices'
  invoices_data <- dbGetQuery(con, "SELECT * FROM invoices")
  
  # Actualizar opciones de filtrado
  observe({
    updateSelectInput(session, "country", choices = unique(invoices_data$ShipCountry))
  })
  
  # Filtrar datos por país
  filtered_data <- reactive({
    if (is.null(input$country)) {
      invoices_data
    } else {
      invoices_data %>% filter(ShipCountry == input$country)
    }
  })
  
  # Calcular totales
  output$total_unit_price <- renderText({
    formatC(sum(filtered_data()$UnitPrice, na.rm = TRUE), format = "f", digits = 2)
  })
  
  output$total_quantity <- renderText({
    formatC(sum(filtered_data()$Quantity, na.rm = TRUE), format = "d", big.mark = ",")
  })
  
  output$total_discount <- renderText({
    paste0(round(sum(filtered_data()$Discount, na.rm = TRUE), 2), "%")
  })
  
  output$total_extended_price <- renderText({
    paste0("$", formatC(sum(filtered_data()$ExtendedPrice, na.rm = TRUE), format = "f", digits = 2))
  })
  
  # Gráfica de precio unitario promedio por país con porcentajes en las barras
  output$avg_unit_price_chart <- renderPlot({
    avg_data <- invoices_data %>%
      group_by(ShipCountry) %>%
      summarise(avg_unit_price = mean(UnitPrice, na.rm = TRUE)) %>%
      arrange(desc(avg_unit_price))
    
    ggplot(avg_data, aes(x = reorder(ShipCountry, avg_unit_price), y = avg_unit_price)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      geom_text(aes(label = paste0(round(avg_unit_price, 2), "%")), 
                position = position_stack(vjust = 0.5), 
                color = "white", size = 5) +
      labs(title = "Precio Unitario Promedio por País", x = "País", y = "Precio Unitario Promedio") +
      coord_flip() +
      theme_minimal()
  })
  
  # Tabla de facturas
  output$invoices_table <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 5))
  })
  
  
  
  
  #Desconexion
  onStop(function() {
    dbDisconnect(con)
  })
}



# Cargar librerías necesarias
library(shiny)
library(DBI)
library(odbc)
library(DT)
library(dplyr)
library(ggplot2)

# Definir la lógica del servidor
server <- function(input, output, session) {
  
  # Conexión a la base de datos
  con <- dbConnect(odbc::odbc(),
                   Driver = "SQL Server",
                   Server = "localhost",
                   Database = "northwind",
                   UID = "sa",
                   PWD = "Admin12345",
                   Port = 1433)
  
  # Cargar datos de la tabla 'developer_info'
  developer_data <- dbGetQuery(con, "SELECT * FROM developer_info")
  
  # Renderizar información del desarrollador en el pie de página
  output$developer_info <- renderUI({
    # Asumiendo que la tabla `developer_info` tiene columnas 'name', 'email', 'github'
    developer_name <- developer_data$name[1]
    developer_email <- developer_data$email[1]
    developer_github <- developer_data$github[1]
    
    div(
      id = "developer-info",
      paste0("Desarrollado por: ", developer_name, " | Contacto: ", developer_email, " | GitHub: ", developer_github)
    )
  })
  
  # Cargar datos de la vista 'invoices'
  invoices_data <- dbGetQuery(con, "SELECT * FROM invoices")
  
  # Actualizar opciones de filtrado en el selectInput
  observe({
    updateSelectInput(session, "country", choices = unique(invoices_data$ShipCountry))
  })
  
  # Filtrar datos por país
  filtered_data <- reactive({
    if (is.null(input$country)) {
      invoices_data
    } else {
      invoices_data %>% filter(ShipCountry == input$country)
    }
  })
  
  # Calcular totales
  output$total_unit_price <- renderText({
    formatC(sum(filtered_data()$UnitPrice, na.rm = TRUE), format = "f", digits = 2)
  })
  
  output$total_quantity <- renderText({
    formatC(sum(filtered_data()$Quantity, na.rm = TRUE), format = "d", big.mark = ",")
  })
  
  output$total_discount <- renderText({
    paste0(round(sum(filtered_data()$Discount, na.rm = TRUE), 2), "%")
  })
  
  output$total_extended_price <- renderText({
    paste0("$", formatC(sum(filtered_data()$ExtendedPrice, na.rm = TRUE), format = "f", digits = 2))
  })
  
  # Gráfica de precio unitario promedio por país con porcentajes en las barras
  output$avg_unit_price_chart <- renderPlot({
    avg_data <- invoices_data %>%
      group_by(ShipCountry) %>%
      summarise(avg_unit_price = mean(UnitPrice, na.rm = TRUE)) %>%
      arrange(desc(avg_unit_price))
    
    ggplot(avg_data, aes(x = reorder(ShipCountry, avg_unit_price), y = avg_unit_price)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      geom_text(aes(label = paste0(round(avg_unit_price, 2), "%")), 
                position = position_stack(vjust = 0.5), 
                color = "white", size = 5) +
      labs(title = "Precio Unitario Promedio por País", x = "País", y = "Precio Unitario Promedio") +
      coord_flip() +
      theme_minimal()
  })
  
  # Tabla de facturas
  output$invoices_table <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 5))
  })
  
  # Desconexión de la base de datos cuando la app se detiene
  onStop(function() {
    dbDisconnect(con)
  })
}
