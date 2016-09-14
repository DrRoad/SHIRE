

plots <- c(
  "Histogram" = "hist",
  "Boxplot" = "boxplot",
  "Scatter" = "scatter"
)


vars <- c(
  "charges" = "charges",
  "age" = "age",
  "BMI" = "bmi",
  "children" = "children"
)

insurance <- read.csv("insurance.csv")


server <- function(input, output, session) {
  
  
  ###From here, Data Explorer
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
  
  
  
  
  
  ### From here, Model generator 
  
  output$modelPage <- renderUI({
    inFile <- input$file1
    
    if(is.null(inFile))
      return(NULL)
    
    output$result <- renderText({
      print("File uploaded")
    })
    
    output$model <- renderPlot({
      if(input$action){hist(insurance$charges)}
    })
    
    
    read.csv(inFile$datapath, header = input$header)
    
    #  A defendent variable
    wellPanel(
      radioButtons("dfvari", 
                   label = "DV(Defendent variable)", 
                   choices = vars, 
                   selected = "charges", 
                   inline=TRUE, 
                   width = '300px'),
      
      
      
      #  Explanatory variables. 
      radioButtons("exvaris", "EV(Explanatory variables):",
                   c("all-except DV","except factors","select"), inline = TRUE),
      
      conditionalPanel(
        condition = "input.exvaris == 'select'",
        checkboxGroupInput("selectedExvaris","Select EVs", vars, inline= TRUE)
      ),
      actionButton("action","Generate Model ",icon("refresh"))
    )
  })
  
}