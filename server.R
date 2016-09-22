plots <- c(
  "Histogram" = "hist",
  "Boxplot" = "boxplot",
  "Scatter" = "scatter"
)


insurance <- read.csv("insurance.csv")

data <- data.frame()
vars <- c()


server <- function(input, output, session) {
  
  ######################################################
  ### From here, Model generator

  
  #어떤 형식의 ev인지 선택
  evMethod <<- reactive(input$exvaris)
  #checkboxGroup에서 받아온 evs.
  selectedEvs <<- reactive(input$evSelected)
  selectedDv <<- reactive(input$dfvari)


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
      # data read and analyze
      data <<- read.csv(inFile$datapath, header = input$header)  
      #var setting.
      vars <<- colnames(data)
      #except_factors
      except_factors <<- colnames(data)

      output$str <- renderPrint({
        if(!is.null(data)){str(data)}
      })

      i <- 1
      
      while( i <= length(vars)){
          if(is.factor(data[,vars[i]])){
            except_factors <<- setdiff(except_factors, vars[i])
          }
          i<- i+1   
      }
 
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

    checkboxGroupInput("evSelected","Select EVs", setdiff(vars, input$dfvari))

  })

  #Submit EVs button
  output$evButton <- renderUI({

    inFile <- input$file1 
    
    if(is.null(inFile))
      return(NULL)
      
    actionButton("submit","Submit EVs", icon("apple", lib = "glyphicon"))
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

  # tunning model textbox 
  output$tunningBox <- renderUI({
    inFile <- input$file1 
    
    if(is.null(inFile)){
      return (NULL)
    }


    else{

      model = "lm("

      model = paste(model, selectedDv(), "~") 
    
      if(evMethod() == "all")
          evs <<- "."

      else if(evMethod() == "except_factors") 
          evs <<- setdiff(except_factors, selectedDv()) 

      else if(evMethod() == "select")
          evs <<- selectedEvs

      i <- 1
      while( i <= length(evs)){
        if(i==1)
          model = paste(model, evs[i])  
        else
          model = paste(model, "+",evs[i])
        i<- i+1   
      }
      tempModel = paste(model,")")

      textInput("tunnedModel", "Tunning Model", tempModel,width = '500px')
    }
  })


  #model accuracy
  output$modelMeasure<- renderUI({
    inFile <- input$file1 
    
    if(is.null(inFile)){
      output$noData4 <- renderText({
        "Generate Model, please."
      })
      verbatimTextOutput("noData4")
    }
    else{
      output$modelAcc <- renderPrint({
        summary(data)
      })
      verbatimTextOutput("modelAcc")
    }
  })

  #model generator button
  output$generateButton <- renderUI({
    inFile <- input$file1 
    
    if(is.null(inFile))
      return(NULL)

    actionButton("action","Generate Model", icon("grain", lib = "glyphicon"))
  })

 

  # Temporal sample model image
  output$model <- renderPlot({
      if(input$action){hist(insurance$charges)}
  })


  output$value <- renderText({ input$tunnedModel })







  #######################################################
  ###From here, Data Explorer
 
  output$dataPage <- renderUI({
    
      inFile <- input$file1
      
      if(is.null(inFile))
        return(NULL)
    
      plot <- reactive(input$plotType)
      vari <- reactive(input$variable)
      
      # histogram  
      output$plot <- renderPlot({
        
        if(plot() == "hist"){
          switch(vari(),
                 charges = hist(insurance$charges, main = paste("Histogram of",vari())),
                 age = hist(insurance$age, main = paste("Histogram of",vari())),
                 bmi = hist(insurance$bmi, main = paste("Histogram of",vari())),
                 children = hist(insurance$children, main = paste("Histogram of",vari()))
          )
        }
        else if(plot() == "scatter"){
          pairs(insurance[c("age","bmi", "children", "charges")], pch= c(1,2,3), main="Scatter plots")
          
        }
        else if(plot() == "boxplot"){
          switch(vari(),
                 charges = boxplot(insurance$charges, main = paste("Boxplot of",vari()), notch =TRUE),
                 age = boxplot(insurance$age, main = paste("Boxplot of",vari()), notch =TRUE),
                 bmi = boxplot(insurance$bmi, main = paste("Boxplot of",vari()), notch =TRUE),
                 children = boxplot(insurance$children, main = paste("Boxplot of",vari()), notch =TRUE)
          )
        }
      })
      
      #various informations
      output$summary <- renderPrint({
        if(vari() == "age") 
          summary(insurance$age)
        
        else if(vari() == "charges")
          summary(insurance$charges)
        
        else if(vari() == "bmi")
          summary(insurance$bmi)
        
        else if(vari() == "children")
          summary(insurance$children)
      })
      
      output$table <- renderPrint({
        table(insurance$region)
      })
      
      output$col <- renderPrint({
        cor(insurance[c("age", "bmi", "children", "charges")])
      })
      
      #data table
      output$dataTable <- renderDataTable(
        insurance, options = list(pageLength = 5)
      )
    
  })
  
}