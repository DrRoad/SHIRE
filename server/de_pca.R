# setting important variables as a file is inserted.------
observeEvent(input$file3,{
    
    inFile <- input$file3

    if(!(is.null(inFile))){
    # data read and analyze

      # data <<- read.csv(inFile$datapath,stringsAsFactors = F, sep=",", header = input$header,fileEncoding = "CP949", encoding = "UTF-8")
      data <<- read.csv(inFile$datapath,stringsAsFactors = F, sep=",", header = input$header)


      pca_vars <<- colnames(data)

      output$pca_dataTable <- renderDataTable(data, options = list(pageLength = 6)) 
      # setting headItems.
     }
})

# title part ------------------------------------------
output$pca_reportTitle <- renderUI({
  inFile <- input$file3   
  if(is.null(inFile))
    return(NULL)
  else{
    title <- renderText({
      "PCA Preprocessor"
    })
    h3(style ="font-family:Impact; margin-top: 75px; text-align: center;",title()) 
  }
})
output$pca_dataName <- renderUI({
  inFile <- input$file3   
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
output$pca_rawData <- renderUI({

  inFile <- input$file3

  if(is.null(inFile)){
    return (NULL)
  }
  else {
    wellPanel(style = "background-color: WhiteSmoke; margin-top : 15px; margin-bottom: 20px; margin-right: 15px;",
      column(9,dataTableOutput('pca_dataTable')),
      column(3,uiOutput("pca_directivity"))
    )
  }
})
output$pca_directivity <- renderUI({
    
    inFile <- input$file3

    if(is.null(inFile)){
        checkboxGroupInput("pca_changedDirection","Change Directivity", pca_vars)
      }
     else{
        return(NULL)
     }
})
# show raw Data -----------------------------------------
output$pca_preprocessor <- renderUI({

  inFile <- input$file3

  if(is.null(inFile)){
    return (NULL)
  }
  else {
    withBusyIndicatorUI(
      actionButton("pca_preButton","Preprocess", icon("leaf", lib = "glyphicon"))
    )
  }

})

# preButton ------------------------------------
output$ar_infoButton <- renderUI({
  inFile <- input$file2 
  
  if(is.null(inFile))
    return(NULL)
})