####################################################### From here, Data Explorer

output$reportTitle <- renderUI({
  inFile <- input$file1   
  if(is.null(inFile))
    return(NULL)
  else{
    title <- renderText({
      "Statistics Report"
    })
    h3(style ="font-family:Impact; margin-top: 75px; text-align: center;",title()) 
  }
})
output$dataName <- renderUI({
  inFile <- input$file1   
  if(is.null(inFile))
    return(NULL)
  else{
    nameData <- renderText({
      paste("of", inFile$name)
    })
    h4(style ="font-family:Times New Roman; text-align: center; margin-bottom: 10px;",nameData())
  }
})

output$plotType <- renderUI({
   inFile <- input$file1
    
     if(is.null(inFile))
        return(NULL)
     else{
      selectInput("plotType", strong("Plot Type"), plots, selected = "hist")
     }
})

output$variInput <- renderUI({
    inFile <- input$file1
    
    if(is.null(inFile))
      return(NULL)
    else{
      selectInput("variable", strong("Variables"), except_factors)
    }
})

output$plotAnal <- renderUI({
  inFile <- input$file1
    
  if(is.null(inFile))
    return(NULL)
  else{
    wellPanel(
      style="background-color: WhiteSmoke; text-align : center;  margin-left : -15px; padding-bottom: 10px; padding-top: 15px; margin-top : 5px; margin-bottom: 40px;",
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
      style = "background-color: WhiteSmoke; margin-top : 5px; margin-bottom: 100px; margin-left : -15px; padding-top: 15px; text-align: center;",
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
    wellPanel(style = "background-color: WhiteSmoke; margin-top : 15px; margin-bottom: 20px; margin-right: 15px;",dataTableOutput('dataTable'))
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
      selectInput("factorSelector", strong("Factor variables"), factors)
    }
})

output$cor <- renderPrint({
  inFile <- input$file1
    
  if(is.null(inFile))
    return(NULL)

  cor(data[except_factors])
})

