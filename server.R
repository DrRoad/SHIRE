library(shiny)
plots <- c(
  "Histogram" = "hist",
  "Boxplot" = "boxplot",
  "Scatter" = "scatter"
)

insurance <- read.csv("insurance.csv")




server <- function(input, output, session) {
  
######################################################
### From here, Model generator
  data <<- data.frame()
  vars <- c()
  commandLogs <<- c()
  evalLogs <<- c()
  model <<- ""
  tempModel <<- ""
  modelResult<<- list()
  modelCount <<- 1
  modelCount2 <<- 1
  r.square <<- c()
  p.value <<- c()
  except_factors <<- c()
  factors <<- c()

 

  reacVars <- eventReactive(input$insertVariBox,{})
  #어떤 형식의 ev인지 선택
  evMethod <<- reactive(input$exvaris)
  #checkboxGroup에서 받아온 evs.
  selectedEvs <<- reactive(input$evSelected) 
  selectedDv <<- reactive(input$dfvari)
  modelCast <<- reactive(input$tunnedModel)
  plotSelected <<- reactive(input$plotType)
  variSelected <<- reactive(input$variable)
  factorSelected <<- reactive(input$factorSelector)

  summaryQuery <<- reactive({
    paste(gsub(' ','',paste('summary(data$', variSelected(),')')))
  })
  boxplotQuery <<- reactive({
    paste(gsub(' ','',paste('boxplot(data$', variSelected())),',main="', paste("Boxplot of", variSelected()),'",notch= TRUE',')')
  })
  histQuery <<- reactive({
    paste(gsub(' ', '',paste('hist(data$',variSelected())),',main ="', paste("Histogram of",variSelected()),'")')
  })

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
      output$dataTable <- renderDataTable(
        data, options = list(pageLength = 5)
      )
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


#New Column Section ###
#튜닝변수 설정.
  newName <<- reactive(input$newMemName)
  newDes <<- reactive(input$newMemDes)


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


  #model accuracy & visualizing
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

#model generator button
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
          newlog <- paste('------------------------------------------------------------------\n',gsub(" ","",paste(modelCount,'.')),newModel)
        else        
          newlog <- paste(gsub(" ","",paste(modelCount,'.')),newModel)
        
        commandLogs <<- union(commandLogs, paste(newlog,'\n'))   
        modelCount <<- modelCount + 1
        
        output$modelLogs <- renderText({
            print(commandLogs)
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
              newlog <- paste('------------------------------------------------------------------\n',gsub(" ","",paste(modelCount2,'.')),new.p.value,'|', new.r.square)
            else        
              newlog <- paste(gsub(" ","",paste(modelCount2,'.')),new.p.value,'|', new.r.square)
            
            evalLogs <<- union(evalLogs, paste(newlog,'\n'))   
            modelCount2 <<- modelCount2 + 1
            
            output$modelLogs2 <- renderText({
                print(evalLogs)
            })
            verbatimTextOutput("modelLogs2")
          
         }
       }
})




####################################################### From here, Data Explorer
  output$plotType <- renderUI({
     inFile <- input$file1
      
       if(is.null(inFile))
          return(NULL)
       else{
        selectInput("plotType", "Plot Type", plots,selected = "boxplot")
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

}