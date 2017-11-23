shinyUI(pageWithSidebar(
  # Application title
  headerPanel(""),
  # Sidebar with sliders that demonstrate various available options
  wellPanel(
    tags$style(type="text/css", '#leftPanel {width:300px; float:left; margin-left: 18px;}'),
    id = "leftPanel",
    sliderInput("fechacreacion", "Fecha de fundacion",
                min = 1985, max = 2017, value = c(1985,2017)),
    
    selectInput("selSport", "Deporte", sort(unique(entidades$Deporte)), selected = "Futbol", multiple = FALSE,
                selectize = TRUE, width = NULL, size = NULL), 
    
    checkboxInput("allSports", "Todos los deportes", value = FALSE, width = NULL),
    
    conditionalPanel(condition="input.tabselected==1", 
                     selectInput("selMuni", "Municipio", choices_muni, selected = NULL, multiple = FALSE,
                                 selectize = TRUE, width = NULL, size = NULL)),
    
    conditionalPanel(condition="input.tabselected==2",
                     selectInput("selProv", "Provincia", c("Almeria"="04", "Cadiz"="11", "Cordoba" = "14", "Granada" = "18", 
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
                                      selectInput("selMuni2", "Municipio", choices_muni, selected = NULL, 
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
