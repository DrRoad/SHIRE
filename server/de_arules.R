
# setting important variables as a file is inserted.------
observeEvent(input$file2,{
    
    inFile <- input$file2

    if(!(is.null(inFile))){
    # data read and analyze

      shinyjs::show(id = "ar_infoButton")
      shinyjs::show(id = "frequencyPlot")
      shinyjs::show(id = "ar_summary1")
      shinyjs::show(id = "ar_summary2")
      
      
      # data <<- read.csv(inFile$datapath,stringsAsFactors = F, sep="\t", header = input$header,fileEncoding = "CP949", encoding = "UTF-8")
      data <<- read.csv(inFile$datapath,stringsAsFactors = F, sep="\t", header = input$header)

      # setting headItems.
      lst <<- split(data$name,data$uid)
    
      i <- 1
      while(i < 11){
        key <- names(lst[i])
        value <- paste(head(lst[[i]]), collapse = ", ")
        item <- paste(key,"-",value)
        headItems <- append(headItems, item)
        i <- i+1
      }    

      output$lstData <- renderPrint({
          inFile <- input$file2

          if(is.null(inFile))
              return(NULL)
          else
              headItems
      })
  }
})




# title & data name.-------------------------------------
output$reportTitle2 <- renderUI({
  inFile <- input$file2   
  if(is.null(inFile))
    return(NULL)
  else{
    title <- renderText({
      "Statistics Report"
    })
    h3(style ="font-family:Impact; margin-top: 75px; text-align: center;",title()) 
  }
})
output$dataName2 <- renderUI({
  inFile <- input$file2   
  if(is.null(inFile))
    return(NULL)
  else{
    nameData <- renderText({
      paste("of", inFile$name)
    })
    h4(style ="font-family:Times New Roman; text-align: center; margin-bottom: 10px;",nameData())
  }
})

# show the list raw data. -------------------------------- 
output$headItems <- renderUI({

    inFile <- input$file2

    if(is.null(inFile)){
      return (NULL)
    }
    else {
        p(style = "font-size: 17px;",strong("Head Items"))
    }

})
output$listData <- renderUI({

    inFile <- input$file2

    if(is.null(inFile)){
      return (NULL)
    }
    else {
        verbatimTextOutput("lstData")
    }
})
# transButton ------------------------------------
output$ar_infoButton <- renderUI({
  inFile <- input$file2 
  
  if(is.null(inFile))
    return(NULL)

  withBusyIndicatorUI(
    actionButton("ar_transButton","Transaction info", icon("grain", lib = "glyphicon"))
  )
})



# test ------------------------------------------------------
observeEvent(input$ar_transButton, {
    
    withBusyIndicatorServer("ar_transButton", {
     
      aggrData <- lst
      listData <- list()
      
      # delete duplicates
      for (i in 1:length(aggrData)) {
        listData[[i]] <- as.character(aggrData[[i]][!duplicated(aggrData[[i]])])
      }
      # make data as transactions.
      trans <<- as(listData,"transactions") 
    })
})



# frequencyPlot -------------------------------------------
output$frequencyPlot <- renderUI({
    
  if(input$ar_transButton){
    
      shinyjs::hide(id = "ar_infoButton")
      wellPanel(
        style="background-color: WhiteSmoke; text-align : center;  margin-left : 0px; padding-bottom: 10px; padding-top: 15px; margin-top : 15px; margin-bottom: 20px;",
        column(4, uiOutput("ar_plotType")),
        column(4, uiOutput("ar_pointInput")),
        column(4, uiOutput("dimInfo1"),uiOutput("dimInfo2")),
        plotOutput("ar_plot"),
        br(),br(),br(),br(),br(),br()
      )
   
  }
  else{
   return(NULL) 
  }
})
output$ar_plotType <- renderUI({
    
     if(input$ar_transButton){
        selectInput("ar_plotType", strong("Plot Type"), ar_plots, selected = "minSupp")
      }
     else{
        return(NULL)
     }
})
output$ar_pointInput <- renderUI({
    
    if(input$ar_transButton){
      if(ar_plotSelected() == "minSupp"){
             sliderInput("ar_minSuppPoint", strong("Minimum Support"), min = 10, max = 30, value = 15)
        }
      else if(ar_plotSelected() == "topN"){
            sliderInput("ar_topNPoint", "Top N items", min = 0, max = 50, value =25)
      } 
    }
    else{
        return(NULL)
    }
})
output$dimInfo1 <- renderUI({

    if(input$ar_transButton){
      p(strong("Matrix dimension"))
    }
    else {
      return (NULL)
    }

})
output$dimInfo2 <- renderUI({
  
    if(input$ar_transButton)
        verbatimTextOutput("dimension")
    else{
      return(NULL)
     }
})
output$dimension <- renderPrint({
    
    if(input$ar_transButton)
        dim(trans)
    else
        return(NULL)
})
output$ar_plot <- renderPlot({ 
    if(input$ar_transButton){
      if(ar_plotSelected() == "minSupp"){
            par(family = "NanumGothic")
            eval(parse(text=minSuppQuery()))
        }
      else if(ar_plotSelected() == "topN"){
            par(family = "NanumGothic")
            eval(parse(text=topNQuery()))
      }
    }
    else{
      return(NULL)
    }
})

# ar_summary --------------------------------------------------
output$ar_summary1 <- renderUI({

  if(input$ar_transButton)
    p(style="font-size: 17px;",strong("Summary"))
  else
    return(NULL)
})
output$ar_summary2 <- renderUI({
  
  if(input$ar_transButton){
    wellPanel(style = "background-color: White; margin-bottom: 40px; margin-right: 0px; max-height: 300px;
    overflow-y: auto;",verbatimTextOutput("ar_summaryInfo"))
  }
  else{
    return(NULL)
  }
})
output$ar_summaryInfo <- renderPrint({
     
    if(input$ar_transButton)
      summary(trans)
    else
        return(NULL)
})