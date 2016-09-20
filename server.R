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

  #DV Selector
  output$modelPage <- renderUI({
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

      output$str <- renderPrint({
        if(!is.null(data)){str(data)}
      })
      #  A defendent variable    
      selectInput("dfvari", 
           label = "DV(Defendent variable)", 
           choices = vars, 
           selected = vars[1] 
      )
    }

  })

  #EVs choices
  output$modelPage2 <- renderUI({
    inFile <- input$file1 
    
    if(is.null(inFile))
      return(NULL)
    
    evChoice <- reactive(input$exvaris)

    #  Explanatory variables. 
    selectInput("exvaris", "EV(Explanatory variables):",c("all","except_factors","select"))


    #if(evChoice() == "all")
    #    evs <<- setdiff(vars, input$dfvari)

    #else if(evChoice() == "except_factors") 
    #    evs <<- 

    #else if(evChoice() == "all")

  })
  
  #EVs Selector  
  output$modelPage3 <- renderUI({

    checkboxGroupInput("selectedExvaris","Select EVs", setdiff(vars, input$dfvari))

  })

  #Submit EVs button
  output$modelPage4 <- renderUI({

    inFile <- input$file1 
    
    if(is.null(inFile))
      return(NULL)
      
    actionButton("submit","Submit EVs", icon("apple", lib = "glyphicon"))
  })

  #check the data 
  output$modelPage5 <- renderUI({

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
  output$modelPage6 <- renderUI({
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


  #model accuracy
  output$modelPage7 <- renderUI({
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

  # EVs receiver
  output$evReceiver <- renderUI({

    

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