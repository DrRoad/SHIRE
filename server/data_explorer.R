####################################################### From here, Data Explorer

output$dataName <- renderUI({
  inFile <- input$file1
    
     if(is.null(inFile))
        return(NULL)
     else{
        nameData <- renderText({
          paste("Statistics of",inFile$name)
        })
        h3(style ="font-family:Impact; text-align: center;",nameData())
     }
});

output$plotType <- renderUI({
   inFile <- input$file1
    
     if(is.null(inFile))
        return(NULL)
     else{
      selectInput("plotType", "Plot Type", plots, selected = "scatter")
     }
})

output$variInput <- renderUI({
    inFile <- input$file1
    
    if(is.null(inFile))
      return(NULL)
    else{
      selectInput("variable", "Variables", except_factors)
    }
})

output$plotAnal <- renderUI({
  inFile <- input$file1
    
  if(is.null(inFile))
    return(NULL)
  else{
    wellPanel(
      style="background-color: WhiteSmoke;text-align : center;  margin-left : -15px; padding-bottom: 10px; padding-top: 10px; margin-top : 15px;",
      column(6, uiOutput("plotType")),
      column(6, uiOutput("variInput")),
      plotOutput("plot"),
      br(),br(),br(),br(),br(),
      strong(verbatimTextOutput("summary"))
    )
  }
})

output$factorAnal <- renderUI({
  inFile <- input$file1
  
  if(is.null(inFile)){
    return (NULL)
  }
  else{
    wellPanel(
      style = "background-color: WhiteSmoke; margin-top : 15px; padding-top: 15px; ",
      uiOutput("factorInput"),
      uiOutput("tables"),
      br(),
      p(strong("Correlations")),
      verbatimTextOutput("cor")
    )
  }

})

output$rawData <- renderUI({

  inFile <- input$file1

  if(is.null(inFile)){
    return (NULL)
  }
  else {
    wellPanel(style = "background-color: WhiteSmoke; margin-top : 15px; margin-bottom: 15px;",dataTableOutput('dataTable'))
  }

})
      
#various informations
output$summary <- renderPrint({
    inFile <- input$file1
    
    if(is.null(inFile))
      return(NULL)
    else
        eval(parse(text=summaryQuery()))
})

output$plot <- renderPlot({ 
  inFile <- input$file1
    
    if(is.null(inFile))
      return(NULL)
    else{
      if(plotSelected() == "hist"){
             eval(parse(text=histQuery()))
        }
      else if(plotSelected() == "scatter"){
        pairs(data[except_factors], main="Scatter plots")
      }
      else if(plotSelected() == "boxplot"){
            eval(parse(text=boxplotQuery()))
      }
    }
})


output$tables <- renderUI({
  inFile <- input$file1
    
  if(is.null(inFile))
    return(NULL)

  selected <- factorSelected()
    
  output$table <- renderPrint({
    table(data[selected])
  })
  verbatimTextOutput("table")
})

output$factorInput <- renderUI({

   inFile <- input$file1
    
    if(is.null(inFile))
      return(NULL)
    else{
      selectInput("factorSelector", "Factor variables", factors)
    }
})

output$cor <- renderPrint({
  inFile <- input$file1
    
  if(is.null(inFile))
    return(NULL)

  cor(data[except_factors])
})

