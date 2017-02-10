# arules server.R -------------------------------------

# support----------------------------------------------------------------------------
output$support <- renderUI({
  inFile <- input$file2 
  
  if(is.null(inFile)){
    output$ar_noData6 <- renderText({
      "No Data"
    })
    verbatimTextOutput("ar_noData6")
  }
  else{
    #  A defendent variable    
    sliderInput("suppValue", strong("Support %"), min = 0, max = 50, value =5)
  }
})
# confidence----------------------------------------------------------------------------
output$confidence <- renderUI({
  inFile <- input$file2 
  
  if(is.null(inFile)){
    output$ar_noData <- renderText({
      "No Data7"
    })
    verbatimTextOutput("ar_noData7")
  }
  else{
    #  A defendent variable    
    sliderInput("cnfValue", strong("Confidence %"), min = 0, max = 100, value =80)
  }
})

# minlen  ----------------------------------------------------------------------------
output$minlen <- renderUI({
  inFile <- input$file2 
  
  if(is.null(inFile)){
    output$ar_noData8 <- renderText({
      "No Data"
    })
    verbatimTextOutput("ar_noData8")
  }
  else{
    #  A defendent variable    
    sliderInput("minlenValue", strong("Length"), min = 2, max = 10, value =2)
  }
})


# tunning model textbox ----------------------------------------------------------------------------
output$ar_tunningBox <- renderUI({
  inFile <- input$file2
  
  if(is.null(inFile)){
    output$ar_noData5 <- renderText({
        "No Rules"
    })
    verbatimTextOutput("ar_noData5")
  }
  else{
    tempApriori <<- "apriori(trans, parameter = list("
    tempApriori <<- paste(tempApriori,"supp=", ar_suppSelected()*0.01, ",conf=",ar_cnfSelected()*0.01,",minlen=", ar_minlenSelected(),"))")

    textInput("tunnedRules", label=NULL, tempApriori ,width = '700px')
  }
})

# rule generator button ------------------------------------------
output$ar_generateButton <- renderUI({
  inFile <- input$file2 
  
  if(is.null(inFile))
    return(NULL)

  withBusyIndicatorUI(
    actionButton("ar_action","Filter Rules out", icon("grain", lib = "glyphicon"))
  )
})
observeEvent(input$ar_action, {
    
    withBusyIndicatorServer("ar_action", {
     
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
# Arules visualization------------------------------------------
output$ar_modelVis <- renderUI({
  inFile <- input$file2
  
  if(is.null(inFile)){
    output$ar_noDatda15 <- renderText({
        "No Rules"
    })
    verbatimTextOutput("ar_noDatda15")
  }
  if(input$ar_action){
    wellPanel(style = "background-color: White; padding-top: -20px;",
      column(4,selectInput("ar_orderBy", strong("Order By"), ar_orderBy, selected = "support")),
      column(4,selectInput("ar_howMany", strong("How many"), ar_howMany, selected = "10")),br(),br(),br(),br(),br(),
      uiOutput("ar_model")
    )
  }
 
})
output$ar_model <- renderUI({
  
  if(input$ar_action) {
    model <<- isolate(rulesCast())
    query <<- paste("rules", "<<-", model)
    eval(parse(text=query))

    visNetworkOutput("network")
    
  }
  else 
    return(NULL)

})
output$network <- renderVisNetwork({

    graphQuery <- paste(gsub(" ","",paste("ar_graph <<- plot(head(sort(rules,by='",ar_orderBySelected(),"'),n=")),ar_howManySelected(),"), method='graph',control=list(type='items'))")
    
    eval(parse(text=graphQuery))

    ig_df <<- get.data.frame(ar_graph, what="both")

    #data preprocessing
    ifelse(is.na(ig_df$vertices$support),0.00001,ig_df$vertices$support)
    ig_df$vertices$support<-ifelse(is.na(ig_df$vertices$support),0.0001,ig_df$vertices$support)

    par(family = "NanumGothic")
    visNetwork(
      nodes=data.frame(
        id=ig_df$vertices$name
        ,value=ig_df$vertices$support
        ,title=ifelse(ig_df$vertices$label=="",ig_df$vertices$name,ig_df$vertices$label)
        ,ig_df$vertices
      )
      ,edges = ig_df$edges
    )%>%
    visEdges(arrows ="to")%>%
    visOptions(highlightNearest=T)
})

# arules --------------------------------------------

output$arules <- renderUI({

  if(input$ar_action){
    wellPanel(style = "background-color: White; margin-bottom: 20px; margin-right: 0px;",verbatimTextOutput("textArules"))
  }
  else{
     output$ar_noData12 <- renderText({
        "No Rules"
      })
      verbatimTextOutput("ar_noData12")
  }
})
output$textArules <- renderPrint({
    arulesQuery <- paste(gsub(" ","",paste("inspect(head(sort(rules,by='",ar_orderBySelected(),"',decreasing=T),n=")),ar_howManySelected(),"))")

    eval(parse(text=arulesQuery))
    
})





















