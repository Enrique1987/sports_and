shinyServer(function(input, output) {
  
  #Funcion subset
  sub_set <- function(df, colum, val){
    return (df[df[,colum]==val,])
  }

  #Subsets
  deporte <- reactive({
    if(input$allSports == FALSE){
      entidades %>% sub_set("Deporte", tolower(input$selSport))
    }else{
      entidades
    }
  })
  
  pueblo <- reactive({
    entidades %>% sub_set("COD_MUN", input$selMuni)
  })
  
  provincia <- reactive({
    entidades %>% sub_set("CPRO", input$selProv)
  })
  
  
  anoInscripcion <- reactive({ 
    entidades[entidades$Fechainscripcion>= paste(as.character(input$fechacreacion[1]),"-01-01", sep="") & entidades$Fechainscripcion<= paste(as.character(input$fechacreacion[2]),"-01-01", sep=""),]
  })
  
  muni_lv <- reactive({
    if(input$allSports == FALSE){
      entidades %>%  sub_set("COD_MUN", input$selMuni) %>% sub_set("Deporte", input$selSport) 
      #ar[ar$Fechainscripcion>= paste(as.character(input$fechacreacion[1]),"-01-01", sep="") & ar$Fechainscripcion<= paste(as.character(input$fechacreacion[2]),"-01-01", sep=""),]
      
    }else{
      entidades %>%  sub_set("COD_MUN", input$selMuni)
    }
  })
  
  
  # Show the values using an HTML table
  output$values <- renderTable({
    #anoInscripcion()
    h1("Por ahora desactivado")
    #deporte()
    muni_lv()
  })
})