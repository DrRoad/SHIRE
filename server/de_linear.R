####################################################### From here, Data Explorer

# setting important variables as a file is inserted.
observeEvent(input$file1,{
  inFile <- input$file1

  if(!(is.null(inFile))){
   # data read and analyze
      data <<- read.csv(inFile$datapath, header = input$header)  
      #var setting.
      vars <<- colnames(data)
      query <<- ""
    
      #except_factors
      except_factors <<- colnames(data) 
      factors <<- c()

      i <- 1
      while( i <= length(vars)){
          if(is.factor(data[,vars[i]])){
            except_factors <<- setdiff(except_factors, vars[i])
            factors <<- union(factors, vars[i])
          }
          i<- i+1   
      }

      output$dataTable <- renderDataTable(data, options = list(pageLength = 6)) 
  }
})

# title & data name. ----------------------------------
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


# show raw Data -----------------------------------------
output$rawData <- renderUI({

  inFile <- input$file1

  if(is.null(inFile)){
    return (NULL)
  }
  else {
    wellPanel(style = "background-color: WhiteSmoke; margin-top : 15px; margin-bottom: 20px; margin-right: 15px;",dataTableOutput('dataTable'))
  }

})

# plotAnal --------------------------------------------
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
#various informations
output$summary <- renderPrint({
    inFile <- input$file1
    
    if(is.null(inFile))
      return(NULL)
    else
        eval(parse(text=summaryQuery()))
})


# factorAnal ------------------------------------------
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
output$factorInput <- renderUI({

   inFile <- input$file1
    
    if(is.null(inFile))
      return(NULL)
    else{
      selectInput("factorSelector", strong("Factor variables"), factors)
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
output$cor <- renderPrint({
  inFile <- input$file1
    
  if(is.null(inFile))
    return(NULL)

  cor(data[except_factors])
})

