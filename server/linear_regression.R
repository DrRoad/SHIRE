

#DV Selector
output$dvSelector <- renderUI({
  inFile <- input$file1 
  
  if(is.null(inFile)){
    output$noData <- renderText({
      "No Data"
    })
    verbatimTextOutput("noData")
  }
  else{
    #  A defendent variable    
    selectInput("dfvari", 
         label = "DV(Defendent variable)", 
         choices = except_factors, 
         selected = except_factors[1] 
    )
  }

})



#EV Method choices
output$evChoice <- renderUI({
  inFile <- input$file1 
  
  if(is.null(inFile))
    return(NULL)

  #  Explanatory variables. 
  selectInput("exvaris", "EV(Explanatory variables):",c("all","except_factors","select"))

})

#EVs Selector  
output$evSelector <- renderUI({

  wellPanel(
		checkboxGroupInput("evSelected","Select EVs", setdiff(vars, selectedDv())),
		actionButton("addVariBox","Add New variable", icon("apple", lib = "glyphicon"))
  )
  
})


# if addVariable button is clicked, show the textbox.
output$addVariable <- renderUI({
  
  actionButton("addVariBox","Add New variable", icon("apple", lib = "glyphicon"))

})


#check the data 
output$dataType <- renderUI({

  inFile <- input$file1 
  
  if(is.null(inFile)){
    output$noData2 <- renderText({
      "No Data"
    })
    verbatimTextOutput("noData2")
  }
  else{

     output$str <- renderPrint({
        if(!is.null(data)){str(data)}
      })
      verbatimTextOutput("str")
  }
})


#model visualization
output$modelVis <- renderUI({
  inFile <- input$file1 
  
  if(is.null(inFile)){
    output$noData3 <- renderText({
      "No Model"
    })
    verbatimTextOutput("noData3")
  }
  else{
   conditionalPanel(
              condition = "input$action == TRUE",
              plotOutput("model")
            )
  }
})


# tunning vari 
output$tunningVari <- renderUI({

  if(input$addVariBox){
  		
	  	wellPanel(

	  		textInput("newMemName", "New Column Name", placeholder = "ex) age2"),
	  		textInput("newMemDes", "Description",placeholder = "ex) data$age^2"),
	  		actionButton("insertVariBox","Insert", icon("hand-up", lib = "glyphicon"))," ", 
	  		actionButton("closeBox","Close", icon("eye-close", lib = "glyphicon"))
		  )
	}

})


observeEvent(input$addVariBox, {
  
  insertUI(
  		selector = "#evSelector",
  		where = "afterEnd",
  		ui = uiOutput("tunningVari")
  	)
})
observeEvent(input$closeBox, {
	removeUI(
		selector = "#tunningVari")
})
#튜닝변수 추가.
observeEvent(input$insertVariBox, {
  
  if(newName()!="" && newDes()!=""){
    vars <<- union(vars, newName())

    query <<- paste("data$", newName(), "<<-", newDes())
    query <<- gsub(" ","", query)
    eval(parse(text=query))    
  }


  updateCheckboxGroupInput(session, "evSelected",
    label = "Select EVs",
    choices = setdiff(vars, selectedDv()),
    selected = input$evSelected
  )

  output$str <- renderPrint({
      str(data)
  })
})


# tunning model textbox 
output$tunningBox <- renderUI({
  inFile <- input$file1 
  
  if(is.null(inFile)){
    return (NULL)
  }
  else{

    tempModel <<- "lm("
    tempModel <<- paste(tempModel, selectedDv(), "~") 
    if(evMethod() == "all")
        evs <<- "."
    else if(evMethod() == "except_factors") 
        evs <<- setdiff(except_factors, selectedDv()) 
    else if(evMethod() == "select")
        evs <<- selectedEvs()
        

    i <- 1
    while( i <= length(evs)){
      if(i==1)
        tempModel <<- paste(tempModel, evs[i])  
      else
        tempModel <<- paste(tempModel, "+",evs[i])
      i<- i+1   
    }
    tempModel <<- paste(tempModel, ", data)")

    textInput("tunnedModel", "Tunning Model", tempModel ,width = '500px')
  }
})


#model accuracy & visualizing -----------------------------
output$modelMeasure <- renderUI({
  inFile <- input$file1 
  
  if(is.null(inFile)){
    output$noLog1 <- renderText({
      ""
    })
    verbatimTextOutput("noLog1")
  }
  else{
    #put the result into modelResult
    if(input$action){

        model <<- isolate(modelCast())
        query <<- paste("modelResult", "<<-", model)
        eval(parse(text=query))  

        output$modelAcc <- renderPrint({
          # print(query)
          summary(modelResult)
        })
        verbatimTextOutput("modelAcc")
    }
  }
})

#model generator button  --------------------------------------
output$generateButton <- renderUI({
  inFile <- input$file1 
  
  if(is.null(inFile))
    return(NULL)

  actionButton("action","Generate Model", icon("grain", lib = "glyphicon"))
})

# Temporal sample model image
output$model <- renderPlot({
    if(input$action){      
      plot(modelResult, 1)
    }
})


#log UI
output$logs <- renderUI({
   inFile <- input$file1 
  
  if(is.null(inFile)){
    output$noLog1 <- renderText({
      ""
    })
    verbatimTextOutput("noLog1")
  }
  else{
    
     if(input$action){
      newModel <- isolate(modelCast())
      
      if(modelCount == 1)
        newlog <- paste('-----------------------------------------------------------------------------------\n',gsub(" ","",paste(modelCount,'.')),newModel)
      else        
        newlog <- paste(gsub(" ","",paste(modelCount,'.')),newModel)
      
      commandLogs <<- union(commandLogs, paste(newlog,'\n'))   
      modelCount <<- modelCount + 1
      
      output$modelLogs <- renderText({
          commandLogs
      })
      verbatimTextOutput("modelLogs")
      
     }
  }
})

#modelEvaluation
output$modelEval <- renderUI({
   inFile <- input$file1 
  
  if(is.null(inFile)){
    output$noLog2 <- renderText({
      ""
    })
    verbatimTextOutput("noLog2")
  }
  else{
        if(input$action){
          new.r.square <- round(summary(modelResult)$adj.r.squared, digits=3)
          new.p.value  <- round(summary(modelResult)$coefficients[1,4], digits=10)

          if(modelCount2 == 1)
            newlog <- paste('------------------------------------------------------------------------------------\n',gsub(" ","",paste(modelCount2,'.')),new.p.value,'|', new.r.square)
          else        
            newlog <- paste(gsub(" ","",paste(modelCount2,'.')),new.p.value,'|', new.r.square)
          
          evalLogs <<- union(evalLogs, paste(newlog,'\n'))   
          modelCount2 <<- modelCount2 + 1
          
          output$modelLogs2 <- renderText({
             evalLogs
          })
          verbatimTextOutput("modelLogs2")
        
       }
     }
})