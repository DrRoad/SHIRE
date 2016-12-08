####################################################### From here, Data Explorer
output$plotType <- renderUI({
   inFile <- input$file1
    
     if(is.null(inFile))
        return(NULL)
     else{
      selectInput("plotType", "Plot Type", plots, selected = "hist")
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
      style="background-color: WhiteSmoke;text-align : center; margin-top: -10px; margin-left : -15px; padding-bottom:10px",
      plotOutput("plot"),
      br(),br(),br(),br(),
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
      style = "background-color: WhiteSmoke; margin-top: -10px",
      uiOutput("factorInput"),
      uiOutput("tables"),
      br(),
      p(strong("Correlations")),
      verbatimTextOutput("cor")
    )
  }

})

output$dataPage <- renderUI({
    inFile <- input$file1
    
    if(is.null(inFile))
      return(NULL)
    else{
      
      #various informations
      output$summary <- renderPrint({
          eval(parse(text=summaryQuery()))
      })

      output$plot <- renderPlot({ 
        if(plotSelected() == "hist"){
               eval(parse(text=histQuery()))
          }
        else if(plotSelected() == "scatter"){
          pairs(data[except_factors], main="Scatter plots")
        }
        else if(plotSelected() == "boxplot"){
              eval(parse(text=boxplotQuery()))
        }
      })
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
session$onSessionEnded(stopApp)

