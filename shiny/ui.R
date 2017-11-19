#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#tags$style(type="text/css", "select { max-width: 240px; }"),
#tags$style(type="text/css", ".span4 { max-width: 290px; }"),
#tags$style(type="text/css", ".well { max-width: 280px; }")

library(shiny)

datos_pueblos_sort <- datos_pueblos[order(datos_pueblos$Municipio), ]
choices_muni = setNames(datos_pueblos_sort$COD_MUN, stringi::stri_trans_totitle(datos_pueblos_sort$Municipio))
datos$Deporte <- stringi::stri_trans_totitle(datos$Deporte)

shinyUI(pageWithSidebar(
  # Application title
  headerPanel(""),
  # Sidebar with sliders that demonstrate various available options
  wellPanel(
    tags$style(type="text/css", '#leftPanel {width:300px; float:left; margin-left: 18px;}'),
    id = "leftPanel",
    sliderInput("fechacreacion", "Fecha de fundacion",
                min = 1985, max = 2017, value = c(1985,2017)),
    
    selectInput("deporte", "Deporte", sort(unique(datos$Deporte)), selected = "Futbol", multiple = FALSE,
                selectize = TRUE, width = NULL, size = NULL), 
    
    checkboxInput("inputId", "Todos los deportes", value = FALSE, width = NULL),
    
    conditionalPanel(condition="input.tabselected==1", 
                     selectInput("municipios", "Municipio", choices_muni, selected = NULL, multiple = FALSE,
                                 selectize = TRUE, width = NULL, size = NULL)),
    
    conditionalPanel(condition="input.tabselected==2",
                     selectInput("provin", "Provincia", c("Almeria"="04", "Cadiz"="11", "Cordoba" = "14", "Granada" = "18", 
                                                          "Huelva" = "21", "Jaen" = "23", "Malaga" ="29", "Sevilla" = "41"), 
                                 selected = NULL, multiple = FALSE,  selectize = TRUE, width = NULL, size = NULL)),
    
    conditionalPanel(condition="input.tabselected==3",
                     radioButtons(inputId = "provormun", "Entidades", c("Provincias", "Municipios", "CC.AA"), selected = "Provincias"),
                     conditionalPanel(condition="input.provormun=='Provincias'", 
                                      selectInput("provin", "Provincia", c("Almeria"="04", "Cadiz"="11", "Cordoba" = "14", "Granada" = "18", 
                                                                          "Huelva" = "21", "Jaen" = "23", "Malaga" ="29", "Sevilla" = "41"), 
                                                                          selected = NULL, multiple = FALSE,  selectize = TRUE, width = NULL, size = NULL)
                                      ),
                     conditionalPanel(condition="input.provormun=='Municipios'", 
                                      selectInput("municipios", "Municipio", choices_muni, selected = NULL, 
                                                  multiple = FALSE, selectize = TRUE, width = NULL, size = NULL)))
    

    
    
  ),
  # Show a table summarizing the values entered
  mainPanel(tabsetPanel(
    tabPanel("Municipios",  value=1, dataTableOutput('tablemun')),
    tabPanel("Provincias", value=2, dataTableOutput('tableprov')),
    tabPanel("Serie Temporal", value=3,  tableOutput("table")), 
    id = "tabselected"
  ),
  
  titlePanel("Mi aplicasion"),
            
    tableOutput("values")
  )
))
